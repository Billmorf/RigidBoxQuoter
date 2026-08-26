//
//  BoxTemplateListView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 26/8/26.
//

import SwiftUI
import SwiftData

struct BoxTemplateListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: BoxTemplateListViewModel?
    @State private var showingAddSheet: Bool = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel?.templates ?? []) { template in
                    HStack {
                        Text(template.name)
                        Text("\(template.baseLength) x \(template.baseWidth) x \(template.baseHeight)")
                    }
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = BoxTemplateListViewModel(modelContext: modelContext)
                }
            }
            .toolbar {
                Button("Add", systemImage: "plus") {
                    showingAddSheet.toggle()
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                if let viewModel {
                    AddBoxTemplateView(viewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    BoxTemplateListView()
        .modelContainer(for: BoxTemplate.self, inMemory: true)
}
