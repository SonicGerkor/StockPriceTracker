//
//  String+Localization.swift
//  StockPriceTracker
//
//  Created by German Battiston on 10/05/2026.
//

import Foundation

extension String {
    static func localized(_ key: LocalizedKey) -> String {
        NSLocalizedString(key.rawValue, comment: "")
    }
}

enum LocalizedKey: String {
    // General
    case markets            = "markets"
    case symbols_count      = "symbols_count"
    case symbol             = "symbol"
    case start_feed         = "start_feed"
    case stop_feed          = "stop_feed"
    case sort_by            = "sort_by"
    
    // Sort options
    case sort_price         = "sort_price"
    case sort_change        = "sort_change"
    
    // Connection states
    case connected          = "connected"
    case disconnected       = "disconnected"
    case connecting         = "connecting"
    case error_prefix       = "error_prefix"
    
    // Detail screen
    case about              = "about"
    case current_price      = "current_price"
    case previous_price     = "previous_price"
    case change             = "change"
    case change_percent     = "change_percent"
    case data_points        = "data_points"
    case price_history      = "price_history"
    
    // Accessibility
    case connection_status  = "connection_status"
    case feed_toggle_active = "feed_toggle_active"
    case feed_toggle_inactive = "feed_toggle_inactive"
}
