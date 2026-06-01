//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Michael Feely on 28/05/2026.
//

import SwiftUI
import SwiftData

@main
struct FinanceTrackerApp: App {
    let persistence = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(persistence.container)
    }
}
