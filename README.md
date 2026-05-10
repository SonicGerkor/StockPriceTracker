# StockPriceTracker | Real-Time Stock Price Tracker

A SwiftUI iOS app that shows live price updates for 25 stocks, powered by a WebSocket connection that ticks every second.

---

## What it does

- Displays a scrollable list of 25 stock symbols with live prices and color-coded change indicators
- Lets you sort the list by price or by how much a stock has moved
- Tap any stock to open a detail screen with a live price chart and company info
- A **Start / Stop** button controls the feed, and a status badge always shows whether you're connected or not
- Both the List and Detail views update at the same time.
- Tested in both Light and Dark modes.
- Localized in English and Spanish.

---

## How it's built

The app uses only Apple frameworks (SwiftUI, Combine and XCTest).

The code is organized so that the business logic lives separately from the networking and the UI. This makes each piece easy to change or test on its own. All dependencies are wired together in one place at startup, so swapping something out is straightforward.

Price updates flow in one direction: the WebSocket receives a message → the app updates its single source of truth → every screen that's watching automatically refreshes.

---

## Testing approach

Tests cover everything from individual model calculations all the way up to the full screen logic. A fake WebSocket client stands in for the real network, so tests run instantly and never need a connection. 
