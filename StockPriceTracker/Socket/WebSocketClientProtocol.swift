//
//  WebSocketClientProtocol.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import Combine

/// Abstracts a WebSocket connection, enabling easy mocking in unit tests.
protocol WebSocketClientProtocol: AnyObject {
    var messagePublisher: AnyPublisher<String, Never> { get }
    var statePublisher: AnyPublisher<ConnectionState, Never> { get }
    
    func connect()
    func disconnect()
    func send(_ text: String)
}
