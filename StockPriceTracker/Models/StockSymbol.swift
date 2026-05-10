//
//  StockSymbol.swift
//  StockPriceTracker
//
//  Created by German Battiston on 08/05/2026.
//

import Foundation

struct StockSymbol: Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    var price: Double
    var previousPrice: Double
    
    var priceChange: Double { price - previousPrice }
    var priceChangePercent: Double {
        guard previousPrice != 0 else { return 0 }
        return (priceChange / previousPrice) * 100
    }
    var isPositive: Bool { priceChange >= 0 }
}

extension StockSymbol {
    static let seed: [StockSymbol] = [
        .init(id: "AAPL",  name: "Apple Inc.",                  description: "Consumer electronics, software and services giant behind the iPhone, Mac, and App Store ecosystems.", price: 189.30, previousPrice: 189.30),
        .init(id: "GOOG",  name: "Alphabet Inc.",               description: "Parent of Google, the world's dominant search engine, alongside YouTube, Cloud, and DeepMind.", price: 174.50, previousPrice: 174.50),
        .init(id: "TSLA",  name: "Tesla Inc.",                  description: "Electric vehicle pioneer and clean-energy company known for the Model S, Y and Gigafactories worldwide.", price: 245.10, previousPrice: 245.10),
        .init(id: "AMZN",  name: "Amazon.com Inc.",             description: "Global e-commerce and cloud computing leader, operating AWS, Prime Video, and Alexa platforms.", price: 185.70, previousPrice: 185.70),
        .init(id: "MSFT",  name: "Microsoft Corp.",             description: "Enterprise software and cloud powerhouse behind Windows, Azure, Office 365, and GitHub.", price: 415.20, previousPrice: 415.20),
        .init(id: "NVDA",  name: "NVIDIA Corp.",                description: "Semiconductor company dominating AI-accelerated computing with its GPU and CUDA platforms.", price: 875.40, previousPrice: 875.40),
        .init(id: "META",  name: "Meta Platforms Inc.",         description: "Social media conglomerate operating Facebook, Instagram, WhatsApp, and the Reality Labs AR/VR division.", price: 512.30, previousPrice: 512.30),
        .init(id: "NFLX",  name: "Netflix Inc.",                description: "Streaming entertainment service with over 260 million paid subscribers across 190+ countries.", price: 630.80, previousPrice: 630.80),
        .init(id: "AMD",   name: "Advanced Micro Devices",      description: "Semiconductor company competing in CPUs, GPUs, and AI accelerators with its EPYC and Radeon lines.", price: 178.90, previousPrice: 178.90),
        .init(id: "INTC",  name: "Intel Corp.",                 description: "Pioneer of the x86 CPU architecture, pursuing a foundry-first transformation under its IDM 2.0 strategy.", price: 43.20,  previousPrice: 43.20),
        .init(id: "ORCL",  name: "Oracle Corp.",                description: "Enterprise database and cloud infrastructure provider with its flagship Autonomous Database and OCI offerings.", price: 122.50, previousPrice: 122.50),
        .init(id: "CRM",   name: "Salesforce Inc.",             description: "Leader in CRM software, offering Sales Cloud, Service Cloud, and the Einstein AI platform.", price: 284.60, previousPrice: 284.60),
        .init(id: "ADBE",  name: "Adobe Inc.",                  description: "Creative and marketing software provider behind Photoshop, Illustrator, and Adobe Experience Cloud.", price: 525.10, previousPrice: 525.10),
        .init(id: "PYPL",  name: "PayPal Holdings Inc.",        description: "Digital payments platform processing billions of transactions through PayPal, Venmo, and Braintree.", price: 68.40,  previousPrice: 68.40),
        .init(id: "UBER",  name: "Uber Technologies Inc.",      description: "Global mobility platform connecting riders, drivers, couriers, and eaters across 70+ countries.", price: 77.30,  previousPrice: 77.30),
        .init(id: "LYFT",  name: "Lyft Inc.",                   description: "North American ride-hailing and bike-sharing service focused on driver experience and sustainability.", price: 18.50,  previousPrice: 18.50),
        .init(id: "SPOT",  name: "Spotify Technology S.A.",     description: "World's largest audio streaming platform, hosting music, podcasts, and audiobooks for 600M+ users.", price: 315.70, previousPrice: 315.70),
        .init(id: "SNOW",  name: "Snowflake Inc.",              description: "Cloud data warehousing platform enabling seamless sharing and analytics across multi-cloud environments.", price: 172.40, previousPrice: 172.40),
        .init(id: "PLTR",  name: "Palantir Technologies",       description: "Data analytics and AI platform serving government and commercial clients through Gotham and Foundry.", price: 24.80,  previousPrice: 24.80),
        .init(id: "COIN",  name: "Coinbase Global Inc.",        description: "Leading U.S. cryptocurrency exchange offering trading, custody, and staking for digital assets.", price: 218.90, previousPrice: 218.90),
        .init(id: "SQ",    name: "Block Inc.",                  description: "Fintech conglomerate operating Square POS, Cash App, and the TIDAL music streaming service.", price: 74.20,  previousPrice: 74.20),
        .init(id: "SHOP",  name: "Shopify Inc.",                description: "Commerce platform powering millions of merchants worldwide with storefronts, payments, and fulfillment.", price: 78.60,  previousPrice: 78.60),
        .init(id: "ZM",    name: "Zoom Video Communications",   description: "Cloud meetings and collaboration platform that became essential infrastructure during the remote-work era.", price: 63.10, previousPrice: 63.10),
        .init(id: "ABNB",  name: "Airbnb Inc.",                 description: "Online marketplace connecting travelers with unique short-term accommodations in over 220 countries.", price: 155.20, previousPrice: 155.20),
        .init(id: "RBLX",  name: "Roblox Corp.",                description: "Immersive gaming and metaverse platform with 60M+ daily active users creating and playing user-built experiences.", price: 41.70, previousPrice: 41.70),
    ]
}
