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
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Hourly rate:", text: $hourlyRateText)
                    .keyboardType(.decimalPad)
            }
            .onAppear {
                if let settings = allSettings.first {
                    hourlyRateText = String(settings.hourlyRate)
                }
            }
            .toolbar {
                Button("Save") {
                    guard let newRate = Double(hourlyRateText) else { return }
                    if let settings = allSettings.first {
                        settings.hourlyRate = newRate
                    } else {
                        let newSetting = AppSettings(hourlyRate: newRate)
                        modelContext.insert(newSetting)
                    }
                    dismiss()
                }
            }
        }
    }
}
    
    #Preview {
        SettingsView()
    }

