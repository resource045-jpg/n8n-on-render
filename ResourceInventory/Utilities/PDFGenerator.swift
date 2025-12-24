//
//  PDFGenerator.swift
//  ResourceInventory
//
//  Utility for generating PDF documents
//

import UIKit
import PDFKit

struct PDFGenerator {
    static func generateProductPDF(product: DigitalProduct) -> URL {
        let pdfMetaData = [
            kCGPDFContextTitle: product.title,
            kCGPDFContextAuthor: "Resource",
            kCGPDFContextSubject: "Digital Product Card"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth: CGFloat = 8.5 * 72.0
        let pageHeight: CGFloat = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { context in
            context.beginPage()

            // Draw content
            drawPDFContent(product: product, in: pageRect)
        }

        // Save to temporary file
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(product.title).pdf")

        try? data.write(to: tempURL)

        return tempURL
    }

    private static func drawPDFContent(product: DigitalProduct, in rect: CGRect) {
        let margin: CGFloat = 50
        var currentY: CGFloat = margin

        // Draw Resource Logo/Header
        let headerFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        let headerText = "Resource"
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: headerFont,
            .foregroundColor: UIColor.systemPurple
        ]
        let headerSize = headerText.size(withAttributes: headerAttributes)
        let headerRect = CGRect(
            x: (rect.width - headerSize.width) / 2,
            y: currentY,
            width: headerSize.width,
            height: headerSize.height
        )
        headerText.draw(in: headerRect, withAttributes: headerAttributes)
        currentY += headerSize.height + 40

        // Draw decorative line
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemPurple.cgColor)
        context?.setLineWidth(2)
        context?.move(to: CGPoint(x: margin, y: currentY))
        context?.addLine(to: CGPoint(x: rect.width - margin, y: currentY))
        context?.strokePath()
        currentY += 30

        // Draw Product Title
        let titleFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.label
        ]
        let titleRect = CGRect(
            x: margin,
            y: currentY,
            width: rect.width - 2 * margin,
            height: 100
        )
        product.title.draw(in: titleRect, withAttributes: titleAttributes)
        currentY += 80

        // Draw Product Type
        let typeFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        let typeAttributes: [NSAttributedString.Key: Any] = [
            .font: typeFont,
            .foregroundColor: UIColor.secondaryLabel
        ]
        let typeText = "النوع: \(product.productType.rawValue)"
        typeText.draw(at: CGPoint(x: margin, y: currentY), withAttributes: typeAttributes)
        currentY += 40

        // Draw Content Box
        currentY += 20
        let contentBoxRect = CGRect(
            x: margin,
            y: currentY,
            width: rect.width - 2 * margin,
            height: 200
        )

        // Background
        context?.setFillColor(UIColor.systemGray6.cgColor)
        context?.fill(contentBoxRect)

        // Border
        context?.setStrokeColor(UIColor.systemGray4.cgColor)
        context?.setLineWidth(1)
        context?.stroke(contentBoxRect)

        // Content text
        let contentFont = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: contentFont,
            .foregroundColor: UIColor.label
        ]
        let contentInset: CGFloat = 15
        let contentTextRect = CGRect(
            x: contentBoxRect.minX + contentInset,
            y: contentBoxRect.minY + contentInset,
            width: contentBoxRect.width - 2 * contentInset,
            height: contentBoxRect.height - 2 * contentInset
        )
        product.contentText.draw(in: contentTextRect, withAttributes: contentAttributes)
        currentY += contentBoxRect.height + 40

        // Draw subscription info if applicable
        if product.hasSubscription, let expirationDate = product.expirationDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "ar")

            let subText = "تاريخ الانتهاء: \(formatter.string(from: expirationDate))"
            let subFont = UIFont.systemFont(ofSize: 14, weight: .medium)
            let subAttributes: [NSAttributedString.Key: Any] = [
                .font: subFont,
                .foregroundColor: UIColor.systemOrange
            ]
            subText.draw(at: CGPoint(x: margin, y: currentY), withAttributes: subAttributes)
            currentY += 30
        }

        // Draw footer
        currentY = rect.height - margin - 40
        let footerFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        let footerAttributes: [NSAttributedString.Key: Any] = [
            .font: footerFont,
            .foregroundColor: UIColor.secondaryLabel
        ]
        let footerText = "تم الإنشاء بواسطة تطبيق Resource Inventory"
        let footerSize = footerText.size(withAttributes: footerAttributes)
        let footerRect = CGRect(
            x: (rect.width - footerSize.width) / 2,
            y: currentY,
            width: footerSize.width,
            height: footerSize.height
        )
        footerText.draw(in: footerRect, withAttributes: footerAttributes)

        // Draw QR code placeholder (optional enhancement)
        // You can add QR code generation here if needed
    }
}
