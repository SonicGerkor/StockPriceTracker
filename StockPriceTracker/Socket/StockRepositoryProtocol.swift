//
//  StockRepositoryProtocol.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import Combine

/// Defines the contract for stock price data access.
/// Conforming types are responsible for managing WebSocket connectivity
/// and publishing canonical symbol state to observers.
protocol StockRepositoryProtocol: AnyObject {
    var symbolsPublisher: AnyPublisher<[StockSymbol], Never> { get }
    
    var connectionStatePublisher: AnyPublisher<ConnectionState, Never> { get }
    
    func startFeed()
    func stopFeed()
}

enum ConnectionState: Equatable {
    case disconnected
    case connecting
    case connected
    case error(String)
    
    var isConnected: Bool { self == .connected }
    
    var displayTitle: String {
        switch self {
        case .disconnected:    return "Disconnected"
        case .connecting:      return "Connecting..."
        case .connected:       return "Connected"
        case .error(let errorMessage):  return "Error: \(errorMessage)"
        }
    }
}
