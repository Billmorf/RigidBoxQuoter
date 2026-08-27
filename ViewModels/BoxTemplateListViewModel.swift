//
//  BoxTemplateListViewModel.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 26/8/26.
//

import SwiftUI
import SwiftData

@Observable
class BoxTemplateListViewModel {
    private var modelContext: ModelContext
    var templates: [BoxTemplate] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchTemplates()
    }
    
    func fetchTemplates() {
        let descriptor = FetchDescriptor<BoxTemplate>(sortBy: [SortDescriptor(\.name)])
        do {
            templates = try modelContext.fetch(descriptor)
        } catch {
            print("Something went wrong")
        }
    }
    
    func addTemplate(name: String, baseLength: Double, baseWidth: Double, baseHeight: Double, lidHeight: Double, laborMinutes: Double, structuralMaterial: RawMaterial, coveringMaterial: RawMaterial) {
        let newTemplate = BoxTemplate(name: name, baseLength: baseLength, baseWidth: baseWidth, baseHeight: baseHeight, lidHeight: lidHeight, laborMinutes: laborMinutes, structuralMaterial: structuralMaterial, coveringMaterial: coveringMaterial)
        modelContext.insert(newTemplate)
        fetchTemplates()
    }
    
    func deleteTemplate(_ template: BoxTemplate) {
        modelContext.delete(template)
        fetchTemplates()
    }
}
