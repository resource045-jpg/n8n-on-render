//
//  AddProductView.swift
//  ResourceInventory
//
//  Smart entry form for adding new products
//

import SwiftUI
import SwiftData

struct AddProductView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var productType: ProductType = .code
    @State private var title = ""

    // For code type
    @State private var codeContent = ""

    // For account type
    @State private var accountEmail = ""
    @State private var accountPassword = ""

    // Subscription
    @State private var hasSubscription = false
    @State private var expirationDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()

    @State private var notes = ""

    @FocusState private var focusedField: Field?

    enum Field {
        case title, code, email, password, notes
    }

    var isValid: Bool {
        !title.isEmpty && (
            (productType == .code && !codeContent.isEmpty) ||
            (productType == .account && !accountEmail.isEmpty && !accountPassword.isEmpty)
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                // Product Type Selection
                Section("نوع المنتج") {
                    Picker("النوع", selection: $productType) {
                        ForEach(ProductType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Title
                Section("العنوان") {
                    TextField("مثال: اشتراك شاهد VIP", text: $title)
                        .focused($focusedField, equals: .title)
                }

                // Content (changes based on type)
                Section("المحتوى") {
                    switch productType {
                    case .code:
                        TextField("أدخل الكود", text: $codeContent, axis: .vertical)
                            .focused($focusedField, equals: .code)
                            .lineLimit(3...6)
                            .font(.system(.body, design: .monospaced))

                    case .account:
                        TextField("البريد الإلكتروني", text: $accountEmail)
                            .focused($focusedField, equals: .email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        SecureField("كلمة المرور", text: $accountPassword)
                            .focused($focusedField, equals: .password)
                            .textContentType(.password)
                    }
                }

                // Subscription
                Section {
                    Toggle("تفعيل تتبع الاشتراك", isOn: $hasSubscription)

                    if hasSubscription {
                        DatePicker(
                            "تاريخ الانتهاء",
                            selection: $expirationDate,
                            in: Date()...,
                            displayedComponents: .date
                        )

                        let days = Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
                        Text("المدة: \(days) يوم")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Label("الاشتراك", systemImage: "clock")
                }

                // Notes
                Section("ملاحظات") {
                    TextField("ملاحظات إضافية (اختياري)", text: $notes, axis: .vertical)
                        .focused($focusedField, equals: .notes)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("إضافة منتج جديد")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("إلغاء") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("حفظ") {
                        saveProduct()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
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

    private func saveProduct() {
        let product = DigitalProduct(
            productType: productType,
            title: title,
            codeContent: productType == .code ? codeContent : nil,
            accountEmail: productType == .account ? accountEmail : nil,
            accountPassword: productType == .account ? accountPassword : nil,
            hasSubscription: hasSubscription,
            expirationDate: hasSubscription ? expirationDate : nil,
            notes: notes.isEmpty ? nil : notes
        )

        modelContext.insert(product)

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        dismiss()
    }
}

#Preview {
    AddProductView()
        .modelContainer(for: DigitalProduct.self, inMemory: true)
}
