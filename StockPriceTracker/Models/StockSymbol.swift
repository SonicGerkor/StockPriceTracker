//
//  StockSymbol.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import Foundation

struct StockSymbol: Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    var price: Double
    var previousPrice: Double
    
    var priceChange: Double { price - previousPrice }
    var priceChangePercent: Double {
        guard previousPrice != 0 else { return 0 }
        return (priceChange / previousPrice) * 100
    }
    var isPositive: Bool { priceChange >= 0 }
}
