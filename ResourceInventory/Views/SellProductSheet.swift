//
//  SellProductSheet.swift
//  ResourceInventory
//
//  Sheet for recording product sale
//

import SwiftUI

struct SellProductSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var product: DigitalProduct

    @State private var buyerName = ""
    @State private var salePrice = ""

    @FocusState private var focusedField: Field?

    enum Field {
        case buyerName, salePrice
    }

    var isValid: Bool {
        !buyerName.isEmpty && !salePrice.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.title)
                            .font(.headline)

                        Label(product.productType.rawValue, systemImage: product.productType.icon)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("المنتج")
                }

                Section {
                    TextField("اسم المشتري", text: $buyerName)
                        .focused($focusedField, equals: .buyerName)

                    HStack {
                        TextField("السعر", text: $salePrice)
                            .focused($focusedField, equals: .salePrice)
                            .keyboardType(.numberPad)

                        Text("ريال")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Label("معلومات البيع", systemImage: "dollarsign.circle")
                }

                Section {
                    Button("تأكيد البيع") {
                        confirmSale()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!isValid)
                    .foregroundStyle(isValid ? .orange : .secondary)
                    .fontWeight(.semibold)
                }
            }
            .navigationTitle("بيع المنتج")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("إلغاء") {
                        dismiss()
                    }
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("تم") {
                        focusedField = nil
                    }
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    private func confirmSale() {
        product.status = .sold
        product.buyerName = buyerName
        product.saleDate = Date()
        product.salePrice = Double(salePrice)

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        dismiss()
    }
}

#Preview {
    SellProductSheet(product: DigitalProduct(
        productType: .code,
        title: "اشتراك شاهد VIP",
        codeContent: "XXXX-YYYY-ZZZZ"
    ))
    .modelContainer(for: DigitalProduct.self, inMemory: true)
}
