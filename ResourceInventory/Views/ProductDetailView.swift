//
//  ProductDetailView.swift
//  ResourceInventory
//
//  Detailed view with sell, share, and PDF features
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var product: DigitalProduct

    @State private var showingSellSheet = false
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Product Header Card
                VStack(spacing: 16) {
                    // Type Badge
                    Label(product.productType.rawValue, systemImage: product.productType.icon)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(colorForType(product.productType.color))
                        .clipShape(Capsule())

                    // Title
                    Text(product.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    // Status
                    Label(product.status.rawValue, systemImage: product.status.icon)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(colorForType(product.status.color))
                        .clipShape(Capsule())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                // Subscription Timer
                if product.hasSubscription {
                    SubscriptionTimerCard(product: product)
                }

                // Content Card
                VStack(alignment: .leading, spacing: 12) {
                    Label("المحتوى", systemImage: "doc.text.fill")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text(product.contentText)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .textSelection(.enabled)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                // Sale Information (if sold)
                if product.status == .sold {
                    SaleInfoCard(product: product)
                }

                // Action Buttons
                VStack(spacing: 12) {
                    if product.status == .available {
                        // Sell Button
                        Button {
                            showingSellSheet = true
                        } label: {
                            Label("بيع المنتج", systemImage: "dollarsign.circle.fill")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }

                    // Share as Text
                    Button {
                        shareAsText()
                    } label: {
                        Label("مشاركة كنص", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    // Share as PDF
                    Button {
                        shareAsPDF()
                    } label: {
                        Label("تصدير PDF", systemImage: "doc.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding()

                // Notes
                if let notes = product.notes {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("ملاحظات", systemImage: "note.text")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        Text(notes)
                            .font(.body)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                // Metadata
                VStack(spacing: 8) {
                    MetadataRow(icon: "calendar", title: "تاريخ الإضافة", value: formatDate(product.createdDate))
                    MetadataRow(icon: "number", title: "المعرف", value: product.id.uuidString.prefix(8).description)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSellSheet) {
            SellProductSheet(product: product)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: shareItems)
        }
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

    private func shareAsText() {
        let text = """
        🎯 \(product.title)

        📦 النوع: \(product.productType.rawValue)

        📄 المحتوى:
        \(product.contentText)

        ━━━━━━━━━━━━━━━
        Powered by Resource 💜
        """

        shareItems = [text]
        showingShareSheet = true

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    private func shareAsPDF() {
        let pdfData = PDFGenerator.generateProductPDF(product: product)
        shareItems = [pdfData]
        showingShareSheet = true

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ar")
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views

struct SubscriptionTimerCard: View {
    let product: DigitalProduct

    var body: some View {
        VStack(spacing: 12) {
            Label("حالة الاشتراك", systemImage: "clock.fill")
                .font(.headline)

            if product.isExpired {
                Text("انتهت الصلاحية")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            } else if let days = product.daysRemaining {
                Text("\(days)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(colorForType(product.timerColor))

                Text("يوم متبقي")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                if let expirationDate = product.expirationDate {
                    Text("ينتهي في: \(formatDate(expirationDate))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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

struct SaleInfoCard: View {
    let product: DigitalProduct

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("معلومات البيع", systemImage: "dollarsign.circle.fill")
                .font(.headline)
                .foregroundStyle(.orange)

            if let buyerName = product.buyerName {
                InfoRow(icon: "person.fill", label: "اسم المشتري", value: buyerName)
            }

            if let saleDate = product.saleDate {
                InfoRow(icon: "calendar", label: "تاريخ البيع", value: formatDate(saleDate))
            }

            if let price = product.salePrice {
                InfoRow(icon: "banknote", label: "السعر", value: "\(Int(price)) ريال")
            }
        }
        .padding()
        .background(.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ar")
        return formatter.string(from: date)
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
}

struct MetadataRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Text(value)
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: DigitalProduct(
            productType: .code,
            title: "اشتراك شاهد VIP",
            codeContent: "XXXX-YYYY-ZZZZ",
            status: .available,
            hasSubscription: true,
            expirationDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
        ))
    }
    .modelContainer(for: DigitalProduct.self, inMemory: true)
}
