//
//  AppContainer.swift
//  StockPriceTracker
//
//  Created by German Battiston on 09/05/2026.
//

import Foundation
import Combine

/// Single source of truth for dependency wiring.
/// Injected as an `@EnvironmentObject` at the root of the view hierarchy.
final class AppContainer: ObservableObject {
    static let shared = AppContainer()
    
    let stockRepository: StockRepositoryProtocol
    let observePriceUpdatesUseCase: ObservePriceUpdatesUseCase
    let sortStocksUseCase: SortStocksUseCase
    
    init(stockRepository: StockRepositoryProtocol = StockRepository()) {
        self.stockRepository = stockRepository
        self.observePriceUpdatesUseCase = ObservePriceUpdatesUseCase(repository: stockRepository)
        self.sortStocksUseCase = SortStocksUseCase()
    }
    
    @MainActor
    func makeStockListViewModel() -> StockListViewModel {
        StockListViewModel(
            observeUseCase: observePriceUpdatesUseCase,
            sortUseCase: sortStocksUseCase
        )
    }
    
    @MainActor
    func makeStockDetailViewModel(symbol: StockSymbol) -> StockDetailViewModel {
        StockDetailViewModel(
            symbol: symbol,
            observeUseCase: observePriceUpdatesUseCase
        )
    }
}
