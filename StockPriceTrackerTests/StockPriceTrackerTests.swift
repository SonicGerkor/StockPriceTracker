//
//  StockPriceTrackerTests.swift
//  StockPriceTrackerTests
//
//  Created by German Battiston on 08/05/2026.
//

import XCTest
import Combine
@testable import StockPriceTracker

final class StockPriceTrackerTests: XCTestCase {
    private var stockRepository: StockRepository!
    private var mockClient: MockWebSocketClient!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        mockClient = MockWebSocketClient()
        stockRepository = StockRepository(webSocketClient: mockClient)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        stockRepository = nil
        mockClient = nil
        
        super.tearDown()
    }
    
    func test_initialState_seedSymbolsArePublished() {
        let exp = expectation(description: "Initial symbols emitted")
        
        stockRepository.symbolsPublisher
            .first()
            .sink { symbols in
                XCTAssertEqual(symbols.count, 25, "Expected 25 seed symbols")
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_initialConnectionState_isDisconnected() {
        let exp = expectation(description: "Initial connection state")
        
        stockRepository.connectionStatePublisher
            .first()
            .sink { state in
                XCTAssertEqual(state, .disconnected)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_startFeed_connectsWebSocket() {
        stockRepository.startFeed()
        XCTAssertEqual(mockClient.connectCallCount, 1)
    }
    
    func test_stopFeed_disconnectsWebSocket() {
        stockRepository.startFeed()
        stockRepository.stopFeed()
        XCTAssertEqual(mockClient.disconnectCallCount, 1)
    }
    
    func test_connectionState_propagatesConnected() {
        let exp = expectation(description: "Connected state received")
        
        stockRepository.connectionStatePublisher
            .filter { $0 == .connected }
            .first()
            .sink { _ in exp.fulfill() }
            .store(in: &cancellables)
        
        // MockClient auto-transitions to .connected
        stockRepository.startFeed()
        wait(for: [exp], timeout: 1)
    }
    
    func test_applyPriceUpdate_updatesSymbolPrice() throws {
        let targetSymbol = StockSymbol.seed[0] // AAPL
        let newPrice = 999.99
        let update = PriceUpdate(symbol: targetSymbol.id, price: newPrice, timestamp: Date())
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(update)
        let text = String(data: data, encoding: .utf8)!
        
        let exp = expectation(description: "Price updated")
        
        stockRepository.symbolsPublisher
            .dropFirst()
            .first()
            .sink { symbols in
                let updated = symbols.first { $0.id == targetSymbol.id }
                XCTAssertEqual(updated?.price ?? 0, newPrice, accuracy: 0.001)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        mockClient.messageSubject.send(text)
        wait(for: [exp], timeout: 1)
    }
    
    func test_applyPriceUpdate_storesPreviousPrice() throws {
        let targetSymbol = StockSymbol.seed[0]
        let originalPrice = targetSymbol.price
        let update = PriceUpdate(symbol: targetSymbol.id, price: 111.11, timestamp: Date())
        
        let encoder = JSONEncoder()
        let text = String(data: try encoder.encode(update), encoding: .utf8)!
        
        let exp = expectation(description: "Previous price stored")
        
        stockRepository.symbolsPublisher
            .dropFirst()
            .first()
            .sink { symbols in
                let updated = symbols.first { $0.id == targetSymbol.id }
                XCTAssertEqual(updated?.previousPrice ?? 0, originalPrice, accuracy: 0.001)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        mockClient.messageSubject.send(text)
        wait(for: [exp], timeout: 1)
    }
    
    func test_malformedMessage_doesNotCrashOrEmit() {
        let exp = expectation(description: "No emission on bad JSON")
        exp.isInverted = true
        
        stockRepository.symbolsPublisher
            .dropFirst()
            .sink { _ in exp.fulfill() }
            .store(in: &cancellables)
        
        mockClient.messageSubject.send("not-valid-json-{{{")
        wait(for: [exp], timeout: 0.3)
    }
    
    func test_unknownSymbol_isIgnored() {
        let update = PriceUpdate(symbol: "UNKNOWN_XYZ", price: 1.0, timestamp: Date())
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let text = try? encoder.encode(update).stringUTF8 else { return }
        
        let exp = expectation(description: "No emission for unknown symbol")
        exp.isInverted = true
        
        stockRepository.symbolsPublisher
            .dropFirst()
            .sink { _ in exp.fulfill() }
            .store(in: &cancellables)
        
        mockClient.messageSubject.send(text)
        wait(for: [exp], timeout: 0.3)
    }
}

private extension Data {
    var stringUTF8: String? { String(data: self, encoding: .utf8) }
}
