//
//  ResourceInventoryApp.swift
//  ResourceInventory
//
//  Digital Product Inventory Management App
//  Created using Swift 6 & SwiftUI
//

import SwiftUI
import SwiftData

@main
struct ResourceInventoryApp: App {
    @StateObject private var authManager = BiometricAuthManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DigitalProduct.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                ContentView()
                    .modelContainer(sharedModelContainer)
            } else {
                BiometricAuthView()
                    .environmentObject(authManager)
            }
        }
    }
}
