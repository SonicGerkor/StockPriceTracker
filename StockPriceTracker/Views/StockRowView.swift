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
        HStack(spacing: 15) {
            Text(symbol.id)
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(1)
                .frame(width: 66, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(symbol.name)
                    .font(.subheadline)
                Text(symbol.id)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text(symbol.price.asCurrency)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                PriceChangeIndicator(symbol: symbol, style: .compact)
            }
        }
        .padding(.vertical, 4)
        .contentTransition(.numericText())
    }
}

#Preview {
    List {
        StockRowView(symbol: StockSymbol.seed[0])
    }
}
