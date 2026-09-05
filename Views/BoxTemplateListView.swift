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
            Group {
                if viewModel?.templates.isEmpty == true {
                    ContentUnavailableView("No Templates Yet", systemImage: "box.fill", description: Text("Add a template to get started"))
                } else {
                    List {
                        ForEach(viewModel?.templates ?? []) { template in
                            HStack {
                                Text(template.name)
                                Text("\(String(format: "%.1f", template.baseLength)) x \(String(format: "%.1f", template.baseWidth)) x \(String(format: "%.1f", template.baseHeight))")
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                if let template = viewModel?.templates[index] {
                                    viewModel?.deleteTemplate(template)
                                }
                            }
                        }
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
