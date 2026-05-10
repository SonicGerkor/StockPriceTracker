//
//  StockRowView.swift
//  StockPriceTracker
//
//  Created by German Battiston on 10/05/2026.
//

import SwiftUI

struct StockRowView: View {
    let symbol: StockSymbol
    
    var body: some View {
        HStack(spacing: 12) {
            // Ticker badge
            Text(symbol.id)
                .font(.system(.headline, design: .monospaced))
                .frame(width: 56, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(symbol.name)
                    .font(.subheadline)
                    .lineLimit(1)
                Text(symbol.id)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(symbol.price.asCurrency)
                    .font(.system(.subheadline, design: .monospaced).weight(.semibold))
                PriceChangeIndicator(symbol: symbol, style: .compact)
            }
        }
        .padding(.vertical, 4)
        .contentTransition(.numericText())
    }
}
