//
//  ContentView.swift
//  ResourceInventory
//
//  Main container view with tab navigation
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var products: [DigitalProduct]

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // قائمة المنتجات
            ProductListView()
                .tabItem {
                    Label("المخزون", systemImage: "square.grid.2x2")
                }
                .tag(0)

            // الإحصائيات
            StatisticsView()
                .tabItem {
                    Label("الإحصائيات", systemImage: "chart.bar.fill")
                }
                .tag(1)

            // الاشتراكات
            SubscriptionsView()
                .tabItem {
                    Label("الاشتراكات", systemImage: "clock.fill")
                }
                .tag(2)

            // الإعدادات
            SettingsView()
                .tabItem {
                    Label("الإعدادات", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: DigitalProduct.self, inMemory: true)
}
