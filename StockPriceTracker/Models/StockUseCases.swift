//
//  StockUseCases.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import Combine

/// Provides a clean API for observing live stock symbols.
/// Isolates ViewModels from the repository layer.
final class ObservePriceUpdatesUseCase {
    
    private let repository: StockRepositoryProtocol
    
    init(repository: StockRepositoryProtocol) {
        self.repository = repository
    }
    
    func symbolsPublisher() -> AnyPublisher<[StockSymbol], Never> {
        repository.symbolsPublisher
    }
    
    func connectionStatePublisher() -> AnyPublisher<ConnectionState, Never> {
        repository.connectionStatePublisher
    }
    
    func startFeed() { repository.startFeed() }
    func stopFeed()  { repository.stopFeed() }
}

/// Sorts an array of StockSymbol according to the chosen strategy.
final class SortStocksUseCase {
    
    enum SortOption: String, CaseIterable, Identifiable {
        case byPrice       = "Price"
        case byPriceChange = "Change"
        
        var id: String { rawValue }
    }
    
    func execute(_ symbols: [StockSymbol], sortedBy option: SortOption) -> [StockSymbol] {
        switch option {
        case .byPrice:
            return symbols.sorted { $0.price > $1.price }
        case .byPriceChange:
            return symbols.sorted { abs($0.priceChangePercent) > abs($1.priceChangePercent) }
        }
    }
}
