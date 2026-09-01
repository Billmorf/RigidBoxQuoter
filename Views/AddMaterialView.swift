//
//  AddMaterialView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 26/7/26.
//

import SwiftUI
import SwiftData

struct AddMaterialView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let viewModel: RawMaterialListViewModel
    @State private var name = ""
    @State private var materialSelected: MaterialUnit = .squareMeter
    @State private var price = ""
    @State private var sheetWidth = ""
    @State private var sheetHeight = ""
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section{
                    TextField("Name", text: $name)
                }
                Section {
                    Picker("Material", selection: $materialSelected) {
                        ForEach(MaterialUnit.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    
                    
                    if materialSelected == .sheet {
                        TextField("Width", text: $sheetWidth)
                            .keyboardType(.decimalPad)
                        TextField("Height", text: $sheetHeight)
                            .keyboardType(.decimalPad)
                    }
                }
                
                TextField("Price", text: $price)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !name.isEmpty else {
                            errorMessage = "Please enter a material name."
                            return
                        }
                        guard let newPrice = Double(price), newPrice > 0 else {
                            errorMessage = "Please enter a valid price."
                            return
                        }
                        if materialSelected == .sheet {
                            if materialSelected == .sheet {
                                guard let shWidth = Double(sheetWidth), let shHeight = Double(sheetHeight), shWidth > 0, shHeight > 0 else {
                                    errorMessage = "Please enter valid dimensions."
                                    return
                                }
                                viewModel.addMaterial(name: name, unit: materialSelected, pricePerUnit: newPrice, sheetWidth: shWidth, sheetHeight: shHeight)
                                dismiss()
                            }
                        } else {
                            viewModel.addMaterial(name: name, unit: materialSelected, pricePerUnit: newPrice, sheetWidth: nil, sheetHeight: nil)
                            dismiss()
                        }
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
    let container = try! ModelContainer(for: RawMaterial.self, configurations: config)
    let viewModel = RawMaterialListViewModel(modelContext: container.mainContext)
    return AddMaterialView(viewModel: viewModel)
        .modelContainer(container)
}
