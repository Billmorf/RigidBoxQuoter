//
//  OfferListView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 28/8/26.
//

import SwiftUI
import SwiftData

struct OfferListView: View {
    @Query(sort: \Offer.date, order: .reverse) private var allOffers: [Offer]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText: String = ""
    
    var filteredOffers: [Offer] {
        if searchText.isEmpty {
            allOffers
        } else {
            allOffers.filter { $0.clientName.localizedCaseInsensitiveContains(searchText)}
        }
    }
    var body: some View {
        NavigationStack {
            if allOffers.isEmpty {
                ContentUnavailableView("No Offers Yet", systemImage: "doc.text", description: Text("Create your first offer to see it here"))
            } else {
                List {
                    ForEach(filteredOffers) { offer in
                        NavigationLink(destination: OfferDetailView(offer: offer)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(offer.clientName)
                                    Text("\(offer.boxTemplateName) · \(offer.quantity) PCS")
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(offer.total, format: .currency(code: "EUR"))
                                        .monospacedDigit()
                                    Text(offer.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        let offersToDelete = indexSet.map { filteredOffers[$0] }
                        for offer in offersToDelete {
                            modelContext.delete(offer)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search by client")
                .navigationTitle("History")
            }
        }
    }
}

#Preview {
    OfferListView()
        .modelContainer(for: Offer.self, inMemory: true)
}
