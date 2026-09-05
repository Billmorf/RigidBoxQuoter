//
//  RawMaterialListView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 26/7/26.
//

import SwiftUI
import SwiftData

struct RawMaterialListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: RawMaterialListViewModel?
    @State private var showingAddSheet: Bool = false
    @State private var materialBeingEdited: RawMaterial?
    @State private var editedPriceText: String = ""
    @State private var showingEditAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel?.materials.isEmpty ?? true {
                    ContentUnavailableView("No Materials Yet", systemImage: "shippingbox.fill", description: Text("Create your first material by tapping the plus button"))
                } else {
                    List {
                        ForEach(viewModel?.materials ?? []) { material in
                            HStack{
                                Text(material.name)
                                Text(material.unit.rawValue)
                                Text(material.pricePerUnit, format: .currency(code: "EUR"))
                                Spacer()
                                Image(systemName: "pencil")
                                    .foregroundStyle(.secondary)
                            }
                            .onTapGesture {
                                materialBeingEdited = material
                                editedPriceText = String(material.pricePerUnit)
                                showingEditAlert = true
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                if let material = viewModel?.materials[index] {
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
                Button("Save") {
                    if let newPrice = Double(editedPriceText), let material = materialBeingEdited {
                        viewModel?.updatePrice(for: material, newPrice: newPrice)
                    }
                }
                Button("Cancel",role: .cancel, action: {})
            }
        }
    }
}

#Preview {
    RawMaterialListView()
        .modelContainer(for: RawMaterial.self, inMemory: true)
}
