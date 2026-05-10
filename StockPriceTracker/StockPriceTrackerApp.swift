//
//  StockPriceTrackerApp.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import SwiftUI

@main
struct StockTrackerApp: App {
    
    @StateObject private var container = AppContainer.shared
    
    var body: some Scene {
        WindowGroup {
            StockListView(viewModel: container.makeStockListViewModel())
                .environmentObject(container)
        }
    }
}
