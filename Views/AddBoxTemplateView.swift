//
//  AddBoxTemplateView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 26/8/26.
//

import SwiftUI
import SwiftData

struct AddBoxTemplateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let viewModel: BoxTemplateListViewModel
    @Query private var allMaterials: [RawMaterial]
    @State private var selectedStructuralMaterial: RawMaterial?
    @State private var selectedCoveringMaterial: RawMaterial?
    @State private var name = ""
    @State private var baseLength = ""
    @State private var baseWidth = ""
    @State private var baseHeight = ""
    @State private var lidHeight = ""
    @State private var laborMinutes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
                
                Section {
                    TextField("Base Length", text: $baseLength)
                        .keyboardType(.decimalPad)
                    TextField("Base Width", text: $baseWidth)
                        .keyboardType(.decimalPad)
                    TextField("Base Height", text: $baseHeight)
                        .keyboardType(.decimalPad)
                    TextField("Lid Height", text: $lidHeight)
                        .keyboardType(.decimalPad)
                    TextField("Labor Minutes", text: $laborMinutes)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Picker("Structural material", selection: $selectedStructuralMaterial) {
                        ForEach(allMaterials) { material in
                            Text(material.name).tag(material as RawMaterial?)
                        }
                    }
                    Picker("Covering material", selection: $selectedCoveringMaterial) {
                        ForEach(allMaterials) { material in
                            Text(material.name).tag(material as RawMaterial?)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard let bLength = Double(baseLength),
                              let bWidth = Double(baseWidth),
                              let bHeight = Double(baseHeight),
                              let lHeight = Double(lidHeight),
                              let labor = Double(laborMinutes),
                              let structural = selectedStructuralMaterial,
                              let covering = selectedCoveringMaterial else { return }
                        
                        viewModel.addTemplate(name: name,baseLength: bLength,baseWidth: bWidth,baseHeight: bHeight,lidHeight: lHeight,laborMinutes: labor,structuralMaterial: structural,coveringMaterial: covering)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BoxTemplate.self, RawMaterial.self, configurations: config)
    let viewModel = BoxTemplateListViewModel(modelContext: container.mainContext)
    return AddBoxTemplateView(viewModel: viewModel)
        .modelContainer(container)
}
