//
//  SettingsView.swift
//  ResourceInventory
//
//  App settings and information
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("enableBiometricAuth") private var enableBiometricAuth = true
    @AppStorage("enableHaptics") private var enableHaptics = true
    @AppStorage("enableNotifications") private var enableNotifications = true

    var body: some View {
        NavigationStack {
            List {
                // Security
                Section {
                    Toggle(isOn: $enableBiometricAuth) {
                        Label("المصادقة البيومترية", systemImage: "faceid")
                    }
                } header: {
                    Label("الأمان", systemImage: "lock.shield.fill")
                } footer: {
                    Text("استخدم FaceID أو TouchID لحماية بياناتك")
                }

                // Preferences
                Section {
                    Toggle(isOn: $enableHaptics) {
                        Label("ردود الفعل اللمسية", systemImage: "hand.tap.fill")
                    }

                    Toggle(isOn: $enableNotifications) {
                        Label("إشعارات انتهاء الاشتراكات", systemImage: "bell.fill")
                    }
                } header: {
                    Label("التفضيلات", systemImage: "slider.horizontal.3")
                } footer: {
                    Text("احصل على إشعار قبل انتهاء الاشتراك بـ 3 أيام")
                }

                // Data
                Section {
                    Button(role: .none) {
                        exportData()
                    } label: {
                        Label("تصدير البيانات", systemImage: "square.and.arrow.up")
                    }

                    Button(role: .none) {
                        importData()
                    } label: {
                        Label("استيراد البيانات", systemImage: "square.and.arrow.down")
                    }
                } header: {
                    Label("البيانات", systemImage: "externaldrive.fill")
                }

                // About
                Section {
                    HStack {
                        Text("الإصدار")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("البناء")
                        Spacer()
                        Text("100")
                            .foregroundStyle(.secondary)
                    }

                    Link(destination: URL(string: "https://resource.com")!) {
                        HStack {
                            Label("الموقع الإلكتروني", systemImage: "safari")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Label("حول التطبيق", systemImage: "info.circle.fill")
                } footer: {
                    VStack(spacing: 8) {
                        Text("Resource Inventory")
                            .font(.headline)

                        Text("تطبيق إدارة المنتجات الرقمية")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("Made with 💜")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("الإعدادات")
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    private func exportData() {
        // TODO: Implement data export
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    private func importData() {
        // TODO: Implement data import
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    SettingsView()
}
