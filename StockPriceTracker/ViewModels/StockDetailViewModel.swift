//
//  StockDetailViewModel.swift
//  StockPriceTracker
//
//  Created by German Battiston on 09/05/2026.
//

import Foundation
import Combine

@MainActor
final class StockDetailViewModel: ObservableObject {
    @Published private(set) var symbol: StockSymbol
    @Published private(set) var connectionState: ConnectionState = .disconnected
    @Published private(set) var priceHistory: [Double] = []
    
    private let observeUseCase: ObservePriceUpdatesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(symbol: StockSymbol, observeUseCase: ObservePriceUpdatesUseCase) {
        self.symbol = symbol
        self.observeUseCase = observeUseCase
        priceHistory = [symbol.price]
        bindPublishers()
    }
    
    private func bindPublishers() {
        observeUseCase.symbolsPublisher()
            .compactMap { symbols in symbols.first(where: { $0.id == self.symbol.id }) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updated in
                guard let self else { return }
                self.symbol = updated
                self.priceHistory.append(updated.price)
                if self.priceHistory.count > 60 { self.priceHistory.removeFirst() }
            }
            .store(in: &cancellables)
        
        observeUseCase.connectionStatePublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$connectionState)
    }
}
