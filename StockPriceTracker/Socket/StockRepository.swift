//
//  StockRepository.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import Combine
import Foundation

/// Concrete repository that:
/// 1. Manages the WebSocket lifecycle.
/// 2. Generates random `PriceUpdate` payloads, sends them through the socket,
///    receives the echo, and applies the update to the local symbol state.
/// 3. Publishes canonical symbol state to all observers.
final class StockRepository: StockRepositoryProtocol {
    
    var symbolsPublisher: AnyPublisher<[StockSymbol], Never> {
        symbolsSubject.eraseToAnyPublisher()
    }
    
    // Handles the state
    var connectionStatePublisher: AnyPublisher<ConnectionState, Never> {
        webSocketClient.statePublisher
    }
    
    private let webSocketClient: WebSocketClientProtocol
    
    private var symbolsMap: [String: StockSymbol]
    private let symbolsSubject: CurrentValueSubject<[StockSymbol], Never>
    
    private var cancellables = Set<AnyCancellable>()
    private var tickerCancellable: AnyCancellable?
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(webSocketClient: WebSocketClientProtocol = WebSocketClient()) {
        self.webSocketClient = webSocketClient
        let initial = StockSymbol.seed
        self.symbolsMap = Dictionary(uniqueKeysWithValues: initial.map { ($0.id, $0) })
        self.symbolsSubject = CurrentValueSubject(initial)
        bindWebSocket()
    }
    
    func startFeed() {
        webSocketClient.connect()
        
        // After connecting, tick every 5 seconds to send a price update for a random symbol.
        tickerCancellable = webSocketClient.statePublisher
            .filter { $0.isConnected }
            .first()
            .flatMap { [weak self] _ -> AnyPublisher<Date, Never> in
                guard self != nil else { return Empty().eraseToAnyPublisher() }
                return Timer.publish(every: 5.0, on: .main, in: .common)
                    .autoconnect()
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] _ in
                self?.sendRandomUpdate()
            }
    }
    
    func stopFeed() {
        tickerCancellable?.cancel()
        tickerCancellable = nil
        webSocketClient.disconnect()
    }
    
    private func bindWebSocket() {
        webSocketClient.messagePublisher
            .compactMap { [weak self] text -> PriceUpdate? in
                guard let self = self,
                      let data = text.data(using: .utf8),
                      let update = try? self.decoder.decode(PriceUpdate.self, from: data)
                else {
                    return nil
                }
                return update
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] update in
                self?.apply(update)
            }
            .store(in: &cancellables)
    }
    
    private func sendRandomUpdate() {
        guard let symbol = symbolsMap.values.randomElement() else { return }
        let update = PriceUpdate.random(for: symbol.id, basePrice: symbol.price)
        
        let encodeResult = Result { try encoder.encode(update) }
        guard case .success(let data) = encodeResult,
              let text = String(data: data, encoding: .utf8)
        else { return }
        
        webSocketClient.send(text)
    }
    
    private func apply(_ update: PriceUpdate) {
        guard var symbol = symbolsMap[update.symbol] else { return }
        symbol.previousPrice = symbol.price
        symbol.price = update.price
        symbolsMap[update.symbol] = symbol
        symbolsSubject.send(Array(symbolsMap.values))
    }
}

