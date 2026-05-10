//
//  StockListView.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import SwiftUI

struct StockListView: View {
    @EnvironmentObject private var container: AppContainer
    
    @StateObject private var viewModel: StockListViewModel
    
    init(viewModel: StockListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerBar
                sortPicker
                symbolList
                    .padding(.vertical, -5)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(String.localized(.markets))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    feedToggleButton
                }
            }
        }
    }
    
    private var headerBar: some View {
        HStack {
            ConnectionStatusView(state: viewModel.connectionState)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
    }
    
    private var sortPicker: some View {
        Picker("Sort by", selection: $viewModel.sortOption) {
            ForEach(SortStocksUseCase.SortOption.allCases) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var symbolList: some View {
        List(viewModel.symbols) { symbol in
            NavigationLink(destination: detailDestination(for: symbol)) {
                StockRowView(symbol: symbol)
            }
            .listRowBackground(Color(.secondarySystemGroupedBackground))
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.symbols.map(\.id))
    }
    
    private var feedToggleButton: some View {
        Button(action: viewModel.toggleFeed) {
            Image(systemName: viewModel.isFeedActive ? "stop.circle.fill" : "play.circle.fill")
        }
        .foregroundStyle(viewModel.isFeedActive ? .red : .green)
        .buttonStyle(.plain)
        .font(.title2)
    }
    
    private func detailDestination(for symbol: StockSymbol) -> some View {
        StockDetailView(
            viewModel: container.makeStockDetailViewModel(symbol: symbol)
        )
    }
}

#Preview {
    StockListView(viewModel: StockListViewModel(
        observeUseCase: ObservePriceUpdatesUseCase(repository: StockRepository()),
        sortUseCase: SortStocksUseCase()
    ))
    .environmentObject(AppContainer.shared)
}
