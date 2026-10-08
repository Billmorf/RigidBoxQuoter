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
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Name") {
                        TextField("e.g. 15x15x10/3", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    LabeledContent("Length") {
                        HStack {
                            TextField("0", text: $baseLength)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text("cm")
                                .foregroundStyle(.secondary)
                        }
                    }
                    LabeledContent("Width") {
                        HStack {
                            TextField("0", text: $baseWidth)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text("cm")
                                .foregroundStyle(.secondary)
                        }
                    }
                    LabeledContent("Height") {
                        HStack {
                            TextField("0", text: $baseHeight)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text("cm")
                                .foregroundStyle(.secondary)
                        }
                    }
                    LabeledContent("Lid Height") {
                        HStack {
                            TextField("0", text: $lidHeight)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text("cm")
                                .foregroundStyle(.secondary)
                        }
                    }
                    LabeledContent("Labor Minutes") {
                        HStack {
                            TextField("0", text: $laborMinutes)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text("min")
                                .foregroundStyle(.secondary)
                        }
                    }
                } footer: {
                    Text("Lid length and width are derived at +0.5 cm.")
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
                        guard !name.isEmpty else {
                            errorMessage = "Please enter a name"
                            return
                        }
                        guard let bLength = baseLength.asDouble,let bWidth = baseWidth.asDouble,let bHeight = baseHeight.asDouble,let lHeight = lidHeight.asDouble, bLength > 0, bWidth > 0, bHeight > 0, lHeight > 0 else {
                            errorMessage = "Please enter valid dimensions"
                            return
                        }
                        guard lHeight <= bHeight else {
                            errorMessage = "Lid height can't be larger than the base height"
                            return
                        }
                        guard let labor = laborMinutes.asDouble, labor > 0 else {
                            errorMessage = "Please enter valid labor time"
                            return
                        }
                        guard let structural = selectedStructuralMaterial,let covering = selectedCoveringMaterial else {
                            errorMessage = "Please select a material"
                            return
                        }
                        
                        
                        viewModel.addTemplate(name: name,baseLength: bLength,baseWidth: bWidth,baseHeight: bHeight,lidHeight: lHeight,laborMinutes: labor,structuralMaterial: structural,coveringMaterial: covering)
                        dismiss()
                    }
                }
            }
            .alert("Invalid Input", isPresented: Binding(
                get: {errorMessage != nil},
                set: { _ in errorMessage = nil}
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
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
