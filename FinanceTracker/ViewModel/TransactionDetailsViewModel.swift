//
//  TransactionDetailsViewModel.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import Foundation
import Combine
import SwiftData

class TransactionDetailsViewModel: ObservableObject{
    
    private let context = PersistenceController.shared.context
    let id: UUID
    
    @Published var transaction: Transaction?
    
    var defualtNoTitle = "No Title"
    init(id: UUID) {
        self.id = id
        fetchTransaction()
    }
    
    func deleteClient(){
        let id = self.id
        
        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let transaction = try? context.fetch(descriptor).first else { return }
        context.delete(transaction)
        try? context.save()
    }
    
    func fetchTransaction(){
        let id = self.id
        
        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { $0.id == id }
        )
        
        transaction = try? context.fetch(descriptor).first

    }
    
        
}
