//
//  PersistenceController.swift
//  FinanceTracker
//
//  Created by Michael Feely on 28/05/2026.
//

import Foundation
import SwiftData

class PersistenceController{
    static let shared = PersistenceController()
    
    let container: ModelContainer
    let context: ModelContext
    init() {
        
        let schema = Schema([
            Item.self
        ])
        
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do{
            container = try ModelContainer(for: schema, configurations: [config])
            context = container.mainContext
        }catch{
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    
    
}
