//
//  MockWebSocketClient.swift
//  StockPriceTrackerTests
//
//  Created by German Battiston on 10/05/2026.
//

import Combine
import Foundation
@testable import StockPriceTracker

/// Controllable test double for `WebSocketClientProtocol`.
/// Lets tests push messages and state changes on demand.
final class MockWebSocketClient: WebSocketClientProtocol {
    var messagePublisher: AnyPublisher<String, Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    var statePublisher: AnyPublisher<ConnectionState, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    let messageSubject = PassthroughSubject<String, Never>()
    let stateSubject = CurrentValueSubject<ConnectionState, Never>(.disconnected)

    private(set) var connectCallCount = 0
    private(set) var disconnectCallCount = 0
    private(set) var sentMessages: [String] = []

    func connect() {
        connectCallCount += 1
        stateSubject.send(.connected)
    }
    
    func disconnect() {
        disconnectCallCount += 1
        stateSubject.send(.disconnected)
    }
    
    func send(_ text: String) {
        sentMessages.append(text)
        // Echo back — mirrors wss://ws.postman-echo.com/raw behaviour.
        messageSubject.send(text)
    }
}
