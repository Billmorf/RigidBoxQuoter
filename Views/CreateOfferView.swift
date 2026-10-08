//
//  CreateOfferView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 27/8/26.
//

import SwiftUI
import SwiftData

struct CreateOfferView: View {
    @Query private var allTemplates: [BoxTemplate]
    @Query private var allSettings: [AppSettings]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var clientName = ""
    @State private var selectedTemplate: BoxTemplate?
    @State private var quantityText = ""
    @State private var usingMold = false
    @State private var moldCostText = ""
    @State private var marginPercent = 20.0
    @State private var errorMessage: String?
    
    var calculationResult: OfferCalculationResult? {
        guard let template = selectedTemplate,
              let quantity = Int(quantityText),
              let structuralWidth = template.structuralMaterial.sheetWidth,
              let structuralHeight = template.structuralMaterial.sheetHeight,
              let coveringWidth = template.coveringMaterial.sheetWidth,
              let coveringHeight = template.coveringMaterial.sheetHeight
        else { return nil }
        
        let boxDimensions = BoxDimensions(baseLength: template.baseLength, baseWidth: template.baseWidth, baseHeight: template.baseHeight, lidHeight: template.lidHeight)
        let structuralPricing = MaterialPricingInput(pricePerUnit: template.structuralMaterial.pricePerUnit, sheetWidth: structuralWidth, sheetHeight: structuralHeight)
        let coveringPricing = MaterialPricingInput(pricePerUnit: template.coveringMaterial.pricePerUnit, sheetWidth: coveringWidth, sheetHeight: coveringHeight)
        let moldCost = usingMold ? moldCostText.asDouble ?? 0 : 0
        let input = OfferCalculationInput(box: boxDimensions, structuralMaterial: structuralPricing, coveringMaterial: coveringPricing, laborMinutes: template.laborMinutes, quantity: quantity, hourlyRate: allSettings.first?.hourlyRate ?? 0, moldCost: moldCost, marginPercent: marginPercent)
        
        return PricingCalculator.calculateOffer(input, usingMold: usingMold)
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Client name", text: $clientName)
                    Picker("Box Template", selection: $selectedTemplate) {
                        ForEach(allTemplates) { template in
                            Text(template.name).tag(template as BoxTemplate?)
                        }
                    }
                }
                
                Section {
                    TextField("Quantity", text: $quantityText)
                        .keyboardType(.decimalPad)
                    Toggle("Using Mold", isOn: $usingMold)
                    
                    if usingMold {
                        TextField("Mold Cost", text: $moldCostText)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section {
                    Slider(value: $marginPercent, in: 0...100, step: 1)
                    Text("\(Int(marginPercent))%")
                }
                
                if let result = calculationResult {
                    Section {
                        VStack(spacing: 6) {
                            Text("PRICE PER BOX")
                                .font(.system(.caption, design: .monospaced))
                                .tracking(1.5)
                                .foregroundStyle(.secondary)
                            Text(result.costPerUnit, format: .currency(code: "EUR"))
                                .font(.system(size: 56, weight: .bold, design: .monospaced))
                                .foregroundStyle(Color.accentColor)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Text("\(result.quantity) boxes")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                    }
                    Section {
                        LabeledContent("Materials:", value: result.materialCost, format: .currency(code: "EUR"))
                            .font(.system(.body, design: .monospaced))
                        LabeledContent("Labor:", value: result.laborCost, format: .currency(code: "EUR"))
                            .font(.system(.body, design: .monospaced))
                        LabeledContent("Molds:", value: result.moldCost, format: .currency(code: "EUR"))
                            .font(.system(.body, design: .monospaced))
                        LabeledContent("Subtotal:", value: result.subTotal, format: .currency(code: "EUR"))
                            .font(.system(.body, design: .monospaced))
                        LabeledContent {
                            Text(result.total, format: .currency(code: "EUR"))
                                .font(.system(.title3, design: .monospaced, weight: .bold))
                        } label: {
                            Text("Total")
                                .font(.headline)
                        }
                        LabeledContent("Profit:", value: result.profitAmount, format: .currency(code: "EUR"))
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }
            .toolbar {
                Button("Create Offer") {
                    guard let template = selectedTemplate else {
                        errorMessage = "Please select a template"
                        return
                    }
                    guard let quantity = Int(quantityText), quantity > 0 else {
                        errorMessage = "Please enter a valid quantity"
                        return
                    }
                    if usingMold == true {
                        guard let moldCost = moldCostText.asDouble, moldCost >= 0 else {
                            errorMessage = "Please enter a valid mold cost"
                            return
                        }
                    }
                    guard !clientName.isEmpty else {
                        errorMessage = "Please enter a client name"
                        return
                    }
                    guard let result = calculationResult else { return }
                    let offer = Offer(clientName: clientName, boxTemplateName: template.name, quantity: result.quantity, materialCost: result.materialCost, laborCost: result.laborCost, moldCost: result.moldCost, subTotal: result.subTotal, total: result.total, marginPercent: marginPercent)
                    modelContext.insert(offer)
                    dismiss()
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
    CreateOfferView()
        .modelContainer(for: [BoxTemplate.self, RawMaterial.self, AppSettings.self, Offer.self], inMemory: true)
}
