//
//  OfferDetailView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 28/8/26.
//

import SwiftUI
import SwiftData

func presentShareSheet(url: URL) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootVC = windowScene.windows.first?.rootViewController else { return }
    
    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    rootVC.present(activityVC, animated: true)
}

struct OfferDetailView: View {
    let offer: Offer
    @State private var showingPrintView = false
    
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
            .toolbar {
                Button("Preview"){
                    showingPrintView.toggle()
                }
                Button("Share PDF"){
                    if let url = PDFGenerator.generate(for: offer) {
                        presentShareSheet(url: url)
                    }
                }
            }
            .sheet(isPresented: $showingPrintView){
                OfferPrintableView(offer: offer)
            }
        }
    }
}

#Preview {
        OfferDetailView(offer: Offer(clientName: "Γιώργος Παπαδόπουλος", boxTemplateName: "Κουτί μικρό", quantity: 100, materialCost: 19, laborCost: 100, moldCost: 30, subTotal: 149, total: 178.8, marginPercent: 20))
    }
