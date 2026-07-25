//
//  RigidBoxQuoterApp.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 25/7/26.
//

import SwiftUI
import SwiftData

@main
struct RigidBoxQuoterApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RawMaterial.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
