//
//  RawMaterialListView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 26/7/26.
//

import SwiftUI
import SwiftData

struct RawMaterialListView: View {
    @Query private var allTemplates : [BoxTemplate]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: RawMaterialListViewModel?
    @State private var showingAddSheet: Bool = false
    @State private var materialBeingEdited: RawMaterial?
    @State private var editedPriceText: String = ""
    @State private var showingEditAlert: Bool = false
    @State private var errorMessage : String?
    
    func subtitle(for material: RawMaterial) -> String {
        let unit = material.unit.rawValue.uppercased()
        if let width = material.sheetWidth, let height = material.sheetHeight {
            return "\(unit) · \(String(format: "%g", width)) x \(String(format: "%g", height)) CM"
        }
        return unit
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel?.materials.isEmpty ?? true {
                    ContentUnavailableView("No Materials Yet", systemImage: "shippingbox.fill", description: Text("Create your first material by tapping the plus button"))
                } else {
                    List {
                        ForEach(viewModel?.materials ?? []) { material in
                            HStack{
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(material.name)
                                    Text(subtitle(for: material))
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(material.pricePerUnit, format: .currency(code: "EUR"))
                                    .monospacedDigit()
                                Image(systemName: "pencil")
                                    .foregroundStyle(.secondary)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                materialBeingEdited = material
                                editedPriceText = String(material.pricePerUnit)
                                showingEditAlert = true
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                if let material = viewModel?.materials[index] {
                                    let isUsed = allTemplates.contains { $0.structuralMaterial == material || $0.coveringMaterial == material }
                                    if isUsed {
                                        errorMessage = "Material is used by template box"
                                        continue
                                    }
                                    viewModel?.deleteMaterial(material)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = RawMaterialListViewModel(modelContext: modelContext)
                }
            }
            .navigationTitle("Materials")
            .toolbar {
                Button("Add material", systemImage: "plus") {
                    showingAddSheet.toggle()
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                if let viewModel {
                    AddMaterialView(viewModel: viewModel)
                }
            }
            .alert("Update price", isPresented: $showingEditAlert) {
                TextField("Price", text: $editedPriceText)
                    .keyboardType(.decimalPad)
                Button("Save") {
                    if let newPrice = editedPriceText.asDouble, let material = materialBeingEdited {
                        viewModel?.updatePrice(for: material, newPrice: newPrice)
                    }
                }
                Button("Cancel",role: .cancel, action: {})
            }
            .alert("Can't Delete", isPresented: Binding(
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
    RawMaterialListView()
        .modelContainer(for: [RawMaterial.self, BoxTemplate.self], inMemory: true)
}
