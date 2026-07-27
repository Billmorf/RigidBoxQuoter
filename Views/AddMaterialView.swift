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
                        guard let newPrice = Double(price) else { return }
                        if materialSelected == .sheet {
                            if let shWidth = Double(sheetWidth), let shHeight = Double(sheetHeight) {
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
