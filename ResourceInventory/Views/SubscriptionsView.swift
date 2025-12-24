//
//  SubscriptionsView.swift
//  ResourceInventory
//
//  View for tracking all active subscriptions
//

import SwiftUI
import SwiftData

struct SubscriptionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<DigitalProduct> { $0.hasSubscription == true },
           sort: \DigitalProduct.expirationDate) private var subscriptions: [DigitalProduct]

    var activeSubscriptions: [DigitalProduct] {
        subscriptions.filter { !$0.isExpired }
    }

    var expiredSubscriptions: [DigitalProduct] {
        subscriptions.filter { $0.isExpired }
    }

    var body: some View {
        NavigationStack {
            List {
                // Active Subscriptions
                if !activeSubscriptions.isEmpty {
                    Section {
                        ForEach(activeSubscriptions) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                SubscriptionRow(product: product)
                            }
                        }
                    } header: {
                        Label("الاشتراكات النشطة", systemImage: "checkmark.circle.fill")
                    }
                }

                // Expired Subscriptions
                if !expiredSubscriptions.isEmpty {
                    Section {
                        ForEach(expiredSubscriptions) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                SubscriptionRow(product: product)
                            }
                        }
                    } header: {
                        Label("الاشتراكات المنتهية", systemImage: "xmark.circle.fill")
                    }
                }

                // Empty state
                if subscriptions.isEmpty {
                    Section {
                        EmptyStateView(
                            icon: "clock.badge.questionmark",
                            title: "لا توجد اشتراكات",
                            message: "لم تقم بتفعيل تتبع الاشتراك لأي منتج"
                        )
                        .frame(height: 300)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .navigationTitle("الاشتراكات")
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct SubscriptionRow: View {
    let product: DigitalProduct

    var body: some View {
        HStack(spacing: 16) {
            // Timer Circle
            ZStack {
                Circle()
                    .stroke(colorForType(product.timerColor).opacity(0.3), lineWidth: 3)
                    .frame(width: 60, height: 60)

                VStack(spacing: 2) {
                    if product.isExpired {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundStyle(.red)
                    } else if let days = product.daysRemaining {
                        Text("\(days)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(colorForType(product.timerColor))

                        Text("يوم")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // Product Info
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.headline)

                if let expirationDate = product.expirationDate {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.caption)

                        Text(formatDate(expirationDate))
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }

                if product.isExpired {
                    Text("انتهت الصلاحية")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }

    private func colorForType(_ colorName: String) -> Color {
        switch colorName {
        case "green": return .green
        case "yellow": return .yellow
        case "red": return .red
        default: return .gray
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ar")
        return formatter.string(from: date)
    }
}

#Preview {
    SubscriptionsView()
        .modelContainer(for: DigitalProduct.self, inMemory: true)
}
