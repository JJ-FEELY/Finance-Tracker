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
            TaxSettings.self,
            Transaction.self,
            Client.self,
            Category.self

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
        
        seedDefaultCategoriesIfNeeded()
    }
    
    func seedDefaultCategoriesIfNeeded() {
        let descriptor = FetchDescriptor<Category>()
        let existing = (try? context.fetch(descriptor)) ?? []
        
        guard existing.isEmpty else { return }  // ✅ only seeds once
        
        Category.defaults.forEach { context.insert($0) }
        try? context.save()
    }

}

