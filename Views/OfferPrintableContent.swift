//
//  OfferPrintableContent.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 30/8/26.
//

import SwiftUI

struct OfferPrintableContent: View {
    let offer: Offer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
                    Text("Offer")
                        .font(.largeTitle)
                    Text("Client: \(offer.clientName)")
                    Text("Box: \(offer.boxTemplateName)")
                    Text("Quantity: \(offer.quantity)")
                    Text("Date: \(offer.date.formatted(date: .long, time: .omitted))")
                    Divider()
                    Text("Total: \(offer.total, format: .currency(code: "EUR"))")
                        .font(.title)
                        .bold()
                }
                .padding(40)
    }
}

#Preview {
    OfferPrintableContent(offer: Offer(clientName: "Γιώργος Παπαδόπουλος", boxTemplateName: "Κουτί μικρό", quantity: 100, materialCost: 19, laborCost: 100, moldCost: 30, subTotal: 149, total: 178.8, marginPercent: 20))
}
