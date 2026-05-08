//
//  PriceUpdate.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import Foundation

struct PriceUpdate: Codable, Equatable {
    let symbol: String
    let price: Double
    let timestamp: Date
    
    static func random(for symbol: String, basePrice: Double) -> PriceUpdate {
        let delta = basePrice * Double.random(in: -0.02...0.02)
        let newPrice = max(0.01, basePrice + delta)
        
        return PriceUpdate(
            symbol: symbol,
            price: (newPrice * 100).rounded() / 100,
            timestamp: Date()
        )
    }
}
