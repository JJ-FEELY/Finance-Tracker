//
//  ContentViewModel.swift
//  FinanceTracker
//
//  Created by Michael Feely on 28/05/2026.
//

import Foundation
import Combine
import SwiftData
import _SwiftData_SwiftUI

class ContentViewModel: ObservableObject{
    
    private let context = PersistenceController.shared.context
    
    
    @Published var items: [Item] = []
    
    init(){
        fetchItems()
    }
    
    func fetchItems(){
        let descriptor = FetchDescriptor<Item>()
        do{
            items = try context.fetch(descriptor)
        } catch{
            print("Fetch failed: \(error)")
        }
    }
    
    
    func addItem() {
        let newItem = Item(timestamp: Date())
        context.insert(newItem)
        
        fetchItems()

    }
    
    
    func deleteItems(offsets: IndexSet) {
        for index in offsets {
            context.delete(items[index])
        }
        fetchItems()
    }
}
