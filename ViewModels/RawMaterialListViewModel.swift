//
//  RawMaterialListViewModel.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 25/7/26.
//

import SwiftUI
import SwiftData

@Observable
class RawMaterialListViewModel {
    private var modelContext: ModelContext
    var materials: [RawMaterial] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchMaterials()
    }
    
    func fetchMaterials() {
        let descriptor = FetchDescriptor<RawMaterial>(sortBy: [SortDescriptor(\.name)])
        do {
            materials = try modelContext.fetch(descriptor)
        } catch {
            print("Something went wrong")
        }
    }
    
    func addMaterial (name: String, unit: MaterialUnit, pricePerUnit: Double, sheetWidth: Double? = nil, sheetHeight: Double? = nil) {
        let newMaterial = RawMaterial(name: name, unit: unit, pricePerUnit: pricePerUnit, sheetWidth: sheetWidth, sheetHeight: sheetHeight)
        modelContext.insert(newMaterial)
        fetchMaterials()
    }
    
    func updatePrice(for material: RawMaterial, newPrice: Double) {
        material.pricePerUnit = newPrice
        material.lastUpdated = Date()
    }
    
    func deleteMaterial(_ material: RawMaterial) {
        modelContext.delete(material)
        fetchMaterials()
    }
}
