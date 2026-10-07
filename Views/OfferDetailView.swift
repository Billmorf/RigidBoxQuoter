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
                Section {
                    VStack(spacing: 6) {
                        Text("PRICE PER BOX")
                            .font(.system(.caption, design: .monospaced))
                            .tracking(1.5)
                            .foregroundStyle(.secondary)
                        Text(offer.costPerUnit, format: .currency(code: "EUR"))
                            .font(.system(size: 56, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.accentColor)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
                Section{
                    Text(offer.clientName)
                } header: {
                    Text("CLIENT")
                        .font(.system(.caption, design: .monospaced))
                        .tracking(1)
                }
                Section{
                    LabeledContent("Template", value: offer.boxTemplateName)
                    LabeledContent("Quantity", value: "\(offer.quantity)")
                } header: {
                    Text("BOX")
                        .font(.system(.caption, design: .monospaced))
                        .tracking(1)
                }
                Section{
                    LabeledContent("Materials:", value: offer.materialCost, format: .currency(code: "EUR"))
                        .font(.system(.body, design: .monospaced))
                    LabeledContent("Labor:", value: offer.laborCost, format: .currency(code: "EUR"))
                        .font(.system(.body, design: .monospaced))
                    LabeledContent("Molds:", value: offer.moldCost, format: .currency(code: "EUR"))
                        .font(.system(.body, design: .monospaced))
                    LabeledContent("Subtotal:", value: offer.subTotal, format: .currency(code: "EUR"))
                        .font(.system(.body, design: .monospaced))
                    LabeledContent {
                        Text(offer.total, format: .currency(code: "EUR"))
                            .font(.system(.title3, design: .monospaced, weight: .bold))
                    } label: {
                        Text("Total")
                            .font(.headline)
                    }
                    LabeledContent("Profit:", value: offer.profitAmount, format: .currency(code: "EUR"))
                        .font(.system(.body, design: .monospaced))
                } header: {
                    Text("COST BREAKDOWN")
                        .font(.system(.caption, design: .monospaced))
                        .tracking(1)
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
