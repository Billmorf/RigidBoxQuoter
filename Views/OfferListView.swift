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
            List {
                ForEach(filteredOffers) { offer in
                    NavigationLink(destination: OfferDetailView(offer: offer)) {
                        VStack {
                            Text("Client: \(offer.clientName)")
                            Text("Date: \(offer.date.formatted(date: .abbreviated, time: .omitted))")
                            Text("\(offer.boxTemplateName) - \(offer.quantity)")
                            Text(offer.total, format: .currency(code: "EUR"))
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search by client")
        }
    }
}

#Preview {
    OfferListView()
        .modelContainer(for: Offer.self, inMemory: true)
}
