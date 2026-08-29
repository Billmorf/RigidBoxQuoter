//
//  MainTabView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 29/8/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            RawMaterialListView()
                .tabItem {
                    Label("Materials", systemImage: "square.stack")
                }
            BoxTemplateListView()
                .tabItem {
                    Label("Templates", systemImage: "shippingbox")
                }
            CreateOfferView()
                .tabItem {
                    Label("New Offer", systemImage: "plus.circle")
                }
            OfferListView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [RawMaterial.self, BoxTemplate.self, Offer.self, AppSettings.self], inMemory: true)
}
