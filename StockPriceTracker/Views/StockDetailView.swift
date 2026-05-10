//
//  StockDetailView.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import SwiftUI

struct StockDetailView: View {
    @StateObject private var viewModel: StockDetailViewModel
    
    init(viewModel: StockDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                priceHeader
                descriptionCard
                statsCard
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.symbol.id)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ConnectionStatusView(state: viewModel.connectionState)
            }
        }
    }
    
    private var priceHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.symbol.name)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(viewModel.symbol.price.asCurrency)
                .font(.system(size: 42, weight: .bold, design: .monospaced))
                .contentTransition(.numericText())
                .animation(.spring(duration: 0.3), value: viewModel.symbol.price)
            
            PriceChangeIndicator(symbol: viewModel.symbol, style: .detailed)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("About", systemImage: "info.circle")
                .font(.headline)
            Text(viewModel.symbol.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var statsCard: some View {
        VStack(spacing: 0) {
            statRow(label: "Symbol",        value: viewModel.symbol.id)
            Divider().padding(.leading)
            statRow(label: "Current Price", value: viewModel.symbol.price.asCurrency)
            Divider().padding(.leading)
            statRow(label: "Previous Price", value: viewModel.symbol.previousPrice.asCurrency)
            Divider().padding(.leading)
            statRow(label: "Change",        value: viewModel.symbol.priceChange.asPriceDelta)
            Divider().padding(.leading)
            statRow(label: "Change %",      value: viewModel.symbol.priceChangePercent.asPercent)
            Divider().padding(.leading)
            statRow(label: "Data Points",   value: "\(viewModel.priceHistory.count)")
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(.body, design: .monospaced))
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

#Preview {
    NavigationStack {
        StockDetailView(
            viewModel: StockDetailViewModel(
                symbol: StockSymbol.seed[0],
                observeUseCase: ObservePriceUpdatesUseCase(repository: StockRepository())
            )
        )
    }
}
