//
//  ProductCardView.swift
//  ResourceInventory
//
//  Card component for displaying product in list
//

import SwiftUI

struct ProductCardView: View {
    let product: DigitalProduct

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                // Product type badge
                Label(product.productType.rawValue, systemImage: product.productType.icon)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(colorForType(product.productType.color))
                    .clipShape(Capsule())

                Spacer()

                // Status badge
                Label(product.status.rawValue, systemImage: product.status.icon)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(colorForType(product.status.color))
                    .clipShape(Capsule())
            }

            // Title
            Text(product.title)
                .font(.headline)
                .foregroundStyle(.primary)

            // Subscription timer (if applicable)
            if product.hasSubscription, let days = product.daysRemaining {
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.caption)

                    if product.isExpired {
                        Text("انتهت الصلاحية")
                            .font(.caption)
                            .fontWeight(.semibold)
                    } else {
                        Text("متبقي \(days) يوم")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(colorForType(product.timerColor))
                .clipShape(Capsule())
            }

            // Sale info (if sold)
            if product.status == .sold, let buyerName = product.buyerName {
                HStack(spacing: 6) {
                    Image(systemName: "person.fill")
                        .font(.caption2)
                    Text(buyerName)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private func colorForType(_ colorName: String) -> Color {
        switch colorName {
        case "blue": return .blue
        case "purple": return .purple
        case "green": return .green
        case "orange": return .orange
        case "yellow": return .yellow
        case "red": return .red
        default: return .gray
        }
    }
}

#Preview {
    ProductCardView(product: DigitalProduct(
        productType: .code,
        title: "اشتراك شاهد VIP",
        codeContent: "XXXX-YYYY-ZZZZ",
        status: .available,
        hasSubscription: true,
        expirationDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
    ))
    .padding()
}
