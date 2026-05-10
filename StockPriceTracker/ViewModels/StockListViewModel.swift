//
//  StockListViewModel.swift
//  StockPriceTracker
//
//  Created by German Battiston on 09/05/2026.
//

import Foundation
import Combine

@MainActor
final class StockListViewModel: ObservableObject {
    @Published private(set) var symbols: [StockSymbol] = []
    @Published private(set) var connectionState: ConnectionState = .disconnected
    @Published var sortOption: SortStocksUseCase.SortOption = .byPrice
    
    private let observeUseCase: ObservePriceUpdatesUseCase
    private let sortUseCase: SortStocksUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(observeUseCase: ObservePriceUpdatesUseCase,
         sortUseCase: SortStocksUseCase) {
        self.observeUseCase = observeUseCase
        self.sortUseCase = sortUseCase
        bindPublishers()
    }
    
    var isFeedActive: Bool { connectionState == .connected || connectionState == .connecting }
    
    func toggleFeed() {
        isFeedActive ? observeUseCase.stopFeed() : observeUseCase.startFeed()
    }
    
    private func bindPublishers() {
        // Combine latest symbols + selected sort option and re-sort on every change.
        observeUseCase.symbolsPublisher()
            .combineLatest($sortOption)
            .map { [weak self] symbols, option -> [StockSymbol] in
                self?.sortUseCase.execute(symbols, sortedBy: option) ?? symbols
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$symbols)
        
        observeUseCase.connectionStatePublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$connectionState)
    }
}
