//
//  BiometricAuthView.swift
//  ResourceInventory
//
//  Biometric authentication screen
//

import SwiftUI

struct BiometricAuthView: View {
    @EnvironmentObject var authManager: BiometricAuthManager

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // App Icon/Logo
                VStack(spacing: 16) {
                    Image(systemName: "cube.box.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)

                    Text("Resource")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("إدارة المنتجات الرقمية")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer()

                // Authentication section
                VStack(spacing: 24) {
                    // Biometric icon
                    Image(systemName: authManager.biometricType.icon)
                        .font(.system(size: 64))
                        .foregroundStyle(.white)

                    Text(authManager.biometricType.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    // Authenticate button
                    Button {
                        authManager.authenticate()
                    } label: {
                        Text("فتح التطبيق")
                            .font(.headline)
                            .foregroundStyle(.purple)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 40)

                    // Fallback button
                    if authManager.biometricType != .none {
                        Button {
                            authManager.fallbackAuthentication()
                        } label: {
                            Text("استخدام رمز المرور")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }

                    // Error message
                    if let error = authManager.authenticationError {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red.opacity(0.8))
                            .padding(.horizontal, 40)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    BiometricAuthView()
        .environmentObject(BiometricAuthManager())
}
