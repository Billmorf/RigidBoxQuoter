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
                            VStack {
                                LabeledContent("Client:", value: offer.clientName)
                                LabeledContent("Date:", value: offer.date.formatted(date: .abbreviated, time: .omitted))
                                LabeledContent("Box:", value: offer.boxTemplateName)
                                LabeledContent("Total:", value: offer.total, format: .currency(code: "EUR"))
                                    .monospacedDigit()
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
            }
        }
    }
}

#Preview {
    OfferListView()
        .modelContainer(for: Offer.self, inMemory: true)
}
