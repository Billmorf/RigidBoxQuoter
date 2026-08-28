//
//  OfferDetailView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 28/8/26.
//

import SwiftUI
import SwiftData

struct OfferDetailView: View {
    let offer: Offer
    
    var body: some View {
        NavigationStack{
            List {
                Section("Client") {
                    Text(offer.clientName)
                }
                Section("Box") {
                    Text(offer.boxTemplateName)
                    Text("Quantity: \(offer.quantity)")
                }
                Section("Cost Breakdown"){
                    Text("Materials costs \(String(format: "%.1f", offer.materialCost ))")
                    Text("Labor costs \(String(format: "%.1f", offer.laborCost ))")
                    Text("Mold costs \(String(format: "%.1f", offer.moldCost ))")
                    Text("Subtotal is \(String(format: "%.1f", offer.subTotal ))")
                    Text("Total is \(String(format: "%.1f", offer.total ))")
                    Text("Profit: \(String(format: "%.1f", offer.profitAmount))")
                    Text("Cost per unit: \(String(format: "%.1f", offer.costPerUnit))")
                }
            }
            .navigationTitle(offer.clientName)
        }
    }
}

#Preview {
        OfferDetailView(offer: Offer(clientName: "Γιώργος Παπαδόπουλος", boxTemplateName: "Κουτί μικρό", quantity: 100, materialCost: 19, laborCost: 100, moldCost: 30, subTotal: 149, total: 178.8, marginPercent: 20))
    }
