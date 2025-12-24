//
//  StatisticsView.swift
//  ResourceInventory
//
//  Analytics and statistics view
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Query private var products: [DigitalProduct]

    var availableCount: Int {
        products.filter { $0.status == .available }.count
    }

    var soldCount: Int {
        products.filter { $0.status == .sold }.count
    }

    var codesCount: Int {
        products.filter { $0.productType == .code }.count
    }

    var accountsCount: Int {
        products.filter { $0.productType == .account }.count
    }

    var totalRevenue: Double {
        products.compactMap { $0.salePrice }.reduce(0, +)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Overview Cards
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(
                            title: "إجمالي المنتجات",
                            value: "\(products.count)",
                            icon: "cube.box.fill",
                            color: .blue
                        )

                        StatCard(
                            title: "المنتجات المتاحة",
                            value: "\(availableCount)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )

                        StatCard(
                            title: "المنتجات المباعة",
                            value: "\(soldCount)",
                            icon: "dollarsign.circle.fill",
                            color: .orange
                        )

                        StatCard(
                            title: "إجمالي الإيرادات",
                            value: "\(Int(totalRevenue)) ر.س",
                            icon: "banknote.fill",
                            color: .purple
                        )
                    }

                    // Product Type Distribution
                    VStack(alignment: .leading, spacing: 16) {
                        Text("توزيع الأنواع")
                            .font(.headline)

                        HStack(spacing: 20) {
                            TypeDistributionCard(
                                type: "أكواد",
                                count: codesCount,
                                total: products.count,
                                color: .blue
                            )

                            TypeDistributionCard(
                                type: "حسابات",
                                count: accountsCount,
                                total: products.count,
                                color: .purple
                            )
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // Status Chart
                    if !products.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("حالة المخزون")
                                .font(.headline)

                            Chart {
                                BarMark(
                                    x: .value("الحالة", "متاح"),
                                    y: .value("العدد", availableCount)
                                )
                                .foregroundStyle(.green)

                                BarMark(
                                    x: .value("الحالة", "مباع"),
                                    y: .value("العدد", soldCount)
                                )
                                .foregroundStyle(.orange)
                            }
                            .frame(height: 200)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }

                    // Recent Sales
                    if soldCount > 0 {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("آخر المبيعات")
                                .font(.headline)

                            ForEach(products.filter { $0.status == .sold }.prefix(5)) { product in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(product.title)
                                            .font(.subheadline)
                                            .fontWeight(.medium)

                                        if let buyerName = product.buyerName {
                                            Text(buyerName)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }

                                    Spacer()

                                    if let price = product.salePrice {
                                        Text("\(Int(price)) ر.س")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.orange)
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding()
            }
            .navigationTitle("الإحصائيات")
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TypeDistributionCard: View {
    let type: String
    let count: Int
    let total: Int
    let color: Color

    var percentage: Int {
        guard total > 0 else { return 0 }
        return Int((Double(count) / Double(total)) * 100)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(color)

            Text(type)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("\(percentage)%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(color)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(color.opacity(0.2))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: DigitalProduct.self, inMemory: true)
}
