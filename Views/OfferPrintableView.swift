//
//  OfferPrintableView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 29/8/26.
//

import SwiftUI
import SwiftData

struct OfferPrintableView: View {
    @Environment(\.dismiss) private var dismiss
    let offer: Offer
    
    var body: some View {
        NavigationStack {
            OfferPrintableContent(offer: offer)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Back"){
                            dismiss()
                        }
                    }
                }
        }
    }
}

#Preview {
    OfferPrintableView(offer: Offer(clientName: "Γιώργος Παπαδόπουλος", boxTemplateName: "Κουτί μικρό", quantity: 100, materialCost: 19, laborCost: 100, moldCost: 30, subTotal: 149, total: 178.8, marginPercent: 20))
}
