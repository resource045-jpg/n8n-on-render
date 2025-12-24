//
//  BiometricAuthManager.swift
//  ResourceInventory
//
//  Manager for handling biometric authentication
//

import SwiftUI
import LocalAuthentication

class BiometricAuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var authenticationError: String?

    @AppStorage("enableBiometricAuth") private var enableBiometricAuth = true

    private let context = LAContext()

    var biometricType: BiometricType {
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        case .opticID:
            return .opticID
        @unknown default:
            return .none
        }
    }

    enum BiometricType {
        case faceID
        case touchID
        case opticID
        case none

        var icon: String {
            switch self {
            case .faceID: return "faceid"
            case .touchID: return "touchid"
            case .opticID: return "opticid"
            case .none: return "lock.fill"
            }
        }

        var title: String {
            switch self {
            case .faceID: return "Face ID"
            case .touchID: return "Touch ID"
            case .opticID: return "Optic ID"
            case .none: return "رمز المرور"
            }
        }
    }

    init() {
        // Skip authentication in debug mode or if disabled
        #if DEBUG
        // In debug, you can bypass auth for testing
        // isAuthenticated = true
        #endif

        if !enableBiometricAuth {
            isAuthenticated = true
        }
    }

    func authenticate() {
        guard enableBiometricAuth else {
            isAuthenticated = true
            return
        }

        let reason = "قم بالمصادقة للوصول إلى مخزونك"

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                    self.authenticationError = nil

                    // Haptic feedback
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                } else {
                    self.authenticationError = error?.localizedDescription ?? "فشلت المصادقة"

                    // Haptic feedback
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                }
            }
        }
    }

    func fallbackAuthentication() {
        // For fallback, use device passcode
        let reason = "قم بإدخال رمز المرور للوصول إلى مخزونك"

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                    self.authenticationError = nil

                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                } else {
                    self.authenticationError = error?.localizedDescription ?? "فشلت المصادقة"

                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                }
            }
        }
    }
}
