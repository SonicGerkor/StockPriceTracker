//
//  SharedComponents.swift
//  StockPriceTracker
//
//  Created by German Battiston on 09/05/2026.
//

import SwiftUI

/// Displays the price change for a symbol as a coloured pill or inline text.
struct PriceChangeIndicator: View {
    let symbol: StockSymbol
    
    enum Style { case compact, detailed }
    var style: Style = .compact
    
    var body: some View {
        switch style {
        case .compact:  compactView
        case .detailed: detailedView
        }
    }
    
    private var compactView: some View {
        HStack(spacing: 2) {
            Image(systemName: symbol.isPositive ? "arrow.up.right" : "arrow.down.right")
                .imageScale(.small)
            Text(symbol.priceChangePercent.asPercent)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(symbol.isPositive ? .green : .red)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background((symbol.isPositive ? Color.green : Color.red).opacity(0.12))
        .clipShape(Capsule())
    }
    
    private var detailedView: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol.isPositive ? "arrow.up.right" : "arrow.down.right")
            Text(symbol.priceChange.asPriceDelta)
            Text("(\(symbol.priceChangePercent.asPercent))")
                .foregroundStyle(.secondary)
        }
        .font(.system(.title3, design: .monospaced).weight(.semibold))
        .foregroundStyle(symbol.isPositive ? .green : .red)
        .contentTransition(.numericText())
        .animation(.spring(duration: 0.3), value: symbol.priceChange)
    }
}

/// A small pill that reflects the current WebSocket connection state.
struct ConnectionStatusView: View {
    let state: ConnectionState
    
    private var color: Color {
        switch state {
        case .connected:    return .green
        case .connecting:   return .yellow
        case .disconnected: return .secondary
        case .error:        return .red
        }
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .overlay {
                    if state == .connecting {
                        Circle().stroke(color, lineWidth: 1)
                            .scaleEffect(1.8)
                            .opacity(0.5)
                            .animation(.easeInOut(duration: 0.9).repeatForever(), value: state)
                    }
                }
            Text(state.displayTitle)
                .font(.caption.weight(.medium))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .clipShape(Capsule())
    }
}

extension Double {
    var asCurrency: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: self)) ?? "$\(self)"
    }
    
    var asPercent: String {
        String(format: "%+.2f% %", self)
    }
    
    var asPriceDelta: String {
        String(format: "%+.2f", self)
    }
}
