//
//  OfferPrintableContent.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 30/8/26.
//

import SwiftUI

struct OfferPrintableContent: View {
    let offer: Offer
    
    private let companyName = "Your Company"
    private let validityDays = 30
    private let paymentTerms = "50% upon order confirmation, 50% before delivery"
    private let deliveryTerms = "Delivery time confirmed upon order"
    private let showVAT = true
    private let vatRate = 0.24
    
    private let navy = Color(red: 0x2C / 255, green: 0x46 / 255, blue: 0x79 / 255)
    private let ink = Color.black
    private let muted = Color(white: 0.4)
    
    private var validUntil: Date {
        Calendar.current.date(byAdding: .day, value: validityDays, to: offer.date) ?? offer.date
    }
    private var vatAmount: Double { offer.total * vatRate }
    private var grandTotal: Double { offer.total + vatAmount }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            
            Rectangle()
                .fill(navy)
                .frame(height: 3)
                .padding(.top, 16)
            
            Text("PREPARED FOR")
                .font(.system(.caption, design: .monospaced))
                .tracking(1.5)
                .foregroundStyle(muted)
                .padding(.top, 32)
            
            Text(offer.clientName)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(ink)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
            
            VStack(spacing: 0) {
                row("Box", offer.boxTemplateName)
                Divider()
                row("Quantity", "\(offer.quantity) pcs")
            }
            .padding(.top, 28)
            
            priceBlock
                .padding(.top, 32)
            
            terms
                .padding(.top, 32)
            
            Spacer(minLength: 0)
        }
        .padding(48)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            Text(companyName)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(navy)
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("QUOTATION")
                    .font(.system(.caption, design: .monospaced))
                    .tracking(1.5)
                    .foregroundStyle(muted)
                Text(offer.date.formatted(date: .long, time: .omitted))
                    .font(.subheadline)
                    .foregroundStyle(ink)
            }
        }
    }
    
    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(muted)
            Spacer()
            Text(value)
                .foregroundStyle(ink)
        }
        .font(.body)
        .padding(.vertical, 12)
    }
    
    private var priceBlock: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("PRICE PER BOX")
                    .font(.system(.caption, design: .monospaced))
                    .tracking(1.5)
                    .foregroundStyle(muted)
                Text(offer.costPerUnit, format: .currency(code: "EUR"))
                    .font(.system(size: 44, weight: .bold, design: .monospaced))
                    .foregroundStyle(navy)
            }
            
            Divider()
            
            amountRow(showVAT ? "SUBTOTAL (EXCL. VAT)" : "TOTAL", offer.total, large: !showVAT)
            
            if showVAT {
                amountRow("VAT \(Int(vatRate * 100))%", vatAmount, large: false)
                Divider()
                amountRow("TOTAL (INCL. VAT)", grandTotal, large: true)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(navy.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func amountRow(_ label: String, _ value: Double, large: Bool) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.system(.caption, design: .monospaced))
                .tracking(1.5)
                .foregroundStyle(muted)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 12)
            Text(value, format: .currency(code: "EUR"))
                .font(.system(size: large ? 24 : 16, weight: large ? .bold : .regular, design: .monospaced))
                .foregroundStyle(ink)
                .layoutPriority(1)
        }
    }
    
    private var terms: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TERMS")
                .font(.system(.caption, design: .monospaced))
                .tracking(1.5)
                .foregroundStyle(muted)
            
            termLine("Validity", "Valid until \(validUntil.formatted(date: .long, time: .omitted))")
            termLine("Payment", paymentTerms)
            termLine("Delivery", deliveryTerms)
            if !showVAT {
                termLine("VAT", "Prices exclude VAT")
            }
        }
    }
    
    private func termLine(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .foregroundStyle(muted)
                .frame(width: 70, alignment: .leading)
            Text(value)
                .foregroundStyle(ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .font(.footnote)
    }
}

#Preview {
    OfferPrintableContent(offer: Offer(clientName: "Γιώργος Παπαδόπουλος", boxTemplateName: "Κουτί μικρό", quantity: 100, materialCost: 19, laborCost: 100, moldCost: 30, subTotal: 149, total: 178.8, marginPercent: 20))
}
