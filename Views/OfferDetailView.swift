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
                    HStack {
                        Text("Materials costs ")
                        Text(offer.materialCost, format: .currency(code: "EUR"))
                    }
                    HStack {
                        Text("Labor costs ")
                        Text(offer.laborCost, format: .currency(code: "EUR"))
                    }
                    HStack {
                        Text("Mold costs ")
                        Text(offer.moldCost, format: .currency(code: "EUR"))
                    }
                    HStack {
                        Text("Subtotal is ")
                        Text(offer.subTotal, format: .currency(code: "EUR"))
                    }
                    HStack {
                        Text("Total is ")
                        Text(offer.total, format: .currency(code: "EUR"))
                    }
                    HStack {
                        Text("Profit: ")
                        Text(offer.profitAmount, format: .currency(code: "EUR"))
                    }
                    HStack {
                        Text("Cost per unit: ")
                        Text(offer.costPerUnit, format: .currency(code: "EUR"))
                    }
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
