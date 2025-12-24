//
//  DigitalProduct.swift
//  ResourceInventory
//
//  SwiftData Model for Digital Products
//

import Foundation
import SwiftData

/// نوع المنتج الرقمي
enum ProductType: String, Codable, CaseIterable {
    case code = "كود"
    case account = "حساب"

    var icon: String {
        switch self {
        case .code: return "qrcode"
        case .account: return "person.crop.circle"
        }
    }

    var color: String {
        switch self {
        case .code: return "blue"
        case .account: return "purple"
        }
    }
}

/// حالة المنتج
enum ProductStatus: String, Codable, CaseIterable {
    case available = "متاح"
    case sold = "تم البيع"

    var icon: String {
        switch self {
        case .available: return "checkmark.circle.fill"
        case .sold: return "dollarsign.circle.fill"
        }
    }

    var color: String {
        switch self {
        case .available: return "green"
        case .sold: return "orange"
        }
    }
}

/// نموذج المنتج الرقمي
@Model
final class DigitalProduct {
    var id: UUID
    var productType: ProductType
    var title: String

    // Content based on type
    var codeContent: String? // For code type
    var accountEmail: String? // For account type
    var accountPassword: String? // For account type

    var status: ProductStatus

    // Sale information
    var buyerName: String?
    var saleDate: Date?
    var salePrice: Double?

    // Subscription tracking
    var hasSubscription: Bool
    var expirationDate: Date?

    // Metadata
    var createdDate: Date
    var notes: String?

    init(
        id: UUID = UUID(),
        productType: ProductType,
        title: String,
        codeContent: String? = nil,
        accountEmail: String? = nil,
        accountPassword: String? = nil,
        status: ProductStatus = .available,
        buyerName: String? = nil,
        saleDate: Date? = nil,
        salePrice: Double? = nil,
        hasSubscription: Bool = false,
        expirationDate: Date? = nil,
        createdDate: Date = Date(),
        notes: String? = nil
    ) {
        self.id = id
        self.productType = productType
        self.title = title
        self.codeContent = codeContent
        self.accountEmail = accountEmail
        self.accountPassword = accountPassword
        self.status = status
        self.buyerName = buyerName
        self.saleDate = saleDate
        self.salePrice = salePrice
        self.hasSubscription = hasSubscription
        self.expirationDate = expirationDate
        self.createdDate = createdDate
        self.notes = notes
    }

    /// محتوى المنتج كنص
    var contentText: String {
        switch productType {
        case .code:
            return codeContent ?? ""
        case .account:
            return "الإيميل: \(accountEmail ?? "")\nالباسورد: \(accountPassword ?? "")"
        }
    }

    /// عدد الأيام المتبقية للاشتراك
    var daysRemaining: Int? {
        guard hasSubscription, let expirationDate = expirationDate else {
            return nil
        }
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: expirationDate).day
        return days
    }

    /// لون العداد الزمني
    var timerColor: String {
        guard let days = daysRemaining else { return "gray" }

        if days > 7 {
            return "green"
        } else if days > 3 {
            return "yellow"
        } else {
            return "red"
        }
    }

    /// هل انتهت صلاحية الاشتراك
    var isExpired: Bool {
        guard hasSubscription, let expirationDate = expirationDate else {
            return false
        }
        return expirationDate < Date()
    }
}
