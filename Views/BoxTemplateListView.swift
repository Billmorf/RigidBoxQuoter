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
    
    func subtitle(for template: BoxTemplate) -> String {
        let bLength = template.baseLength
        let bWidth = template.baseWidth
        let bHeight = template.baseHeight
        let height = template.lidHeight
        let laborMinutes = template.laborMinutes
        let description = "\(String(format: "%g", bLength)) x \(String(format: "%g", bWidth)) x \(String(format: "%g", bHeight)) · LID \(String(format: "%g", height)) CM · \(String(format: "%g", laborMinutes)) MIN"
        return description
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel?.templates.isEmpty == true {
                    ContentUnavailableView("No Templates Yet", systemImage: "box.fill", description: Text("Add a template to get started"))
                } else {
                    List {
                        ForEach(viewModel?.templates ?? []) { template in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(template.name)
                                Text(subtitle(for: template))
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundStyle(.secondary)
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
            .navigationTitle("Box Templates")
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
