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
            Label(String.localized(.about), systemImage: "info.circle")
                .font(.title3)
                .fontWeight(.semibold)
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
            statRow(label: String.localized(.symbol), value: viewModel.symbol.id)
            Divider().padding(.leading)
            statRow(label: String.localized(.current_price), value: viewModel.symbol.price.asCurrency)
            Divider().padding(.leading)
            statRow(label: String.localized(.previous_price), value: viewModel.symbol.previousPrice.asCurrency)
            Divider().padding(.leading)
            statRow(label: String.localized(.change), value: viewModel.symbol.priceChange.asPriceDelta)
            Divider().padding(.leading)
            statRow(label: String.localized(.change_percent), value: viewModel.symbol.priceChangePercent.asPercent)
            Divider().padding(.leading)
            statRow(label: String.localized(.data_points), value: "\(viewModel.priceHistory.count)")
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
