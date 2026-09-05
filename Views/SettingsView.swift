//
//  SettingsView.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 1/8/26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var allSettings: [AppSettings]
    @State private var hourlyRateText: String = ""
    @State private var errorMessage: String?
    @State private var showingInfo: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section ("Hourly rate") {
                    HStack {
                        TextField("Hourly rate:", text: $hourlyRateText)
                            .keyboardType(.decimalPad)
                        Button {
                            showingInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .buttonStyle(.plain)
                        .popover(isPresented: $showingInfo) {
                            Text("The hourly rate is used to calculate labor cost for each offer, based on how many minutes each box takes to assemble.")
                                .padding()
                                .frame(width: 250)
                                .fixedSize(horizontal: false, vertical: true)
                                .presentationCompactAdaptation(.popover)
                        }
                    }
                }
            }
            .onAppear {
                if let settings = allSettings.first {
                    hourlyRateText = String(settings.hourlyRate)
                }
            }
            .toolbar {
                Button("Save") {
                    guard let newRate = Double(hourlyRateText), newRate > 0 else {
                        errorMessage = "Please enter a valid hourly rate."
                        return
                    }
                    if let settings = allSettings.first {
                        settings.hourlyRate = newRate
                    } else {
                        let newSetting = AppSettings(hourlyRate: newRate)
                        modelContext.insert(newSetting)
                    }
                    dismiss()
                }
            }
            .alert("Invalid Input",isPresented: Binding(
                get: { errorMessage != nil},
                set: { _ in errorMessage = nil}
            )) {
                Button("OK", role: .cancel){}
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
}
    
    #Preview {
        SettingsView()
    }

