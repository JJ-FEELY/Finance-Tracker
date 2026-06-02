//
//  AddTransactionViewModel.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import Foundation
import Combine
import SwiftData

class AddTransactionViewModel: ObservableObject{
    
    private let context = PersistenceController.shared.context
    
    @Published var title: String = ""
    @Published var amount: Decimal = 0.0
    @Published var date: Date = Date()
    @Published var transactionType: TransactionType = .income
    @Published var transactionScope: TransactionScope = .business
    @Published var selectedClient: Client?
    @Published var selectedCategory: Category?
    
    @Published var isReccuring: Bool = false
    @Published var saveSuccess: Bool = false
        
    func saveTransaction() {
        let newTransaction =
        Transaction(
            id: UUID(),
            title: title,
            amount: amount,
            type: transactionType,
            transactionScope: transactionScope,
            date: date,
            isReccuring: isReccuring
        )
        newTransaction.client = selectedClient
        
        context.insert(newTransaction)
        
        try? context.save()
        
        saveSuccess = true
    }
    
    func clearForm(){
        title = ""
        amount = 0.0
        isReccuring = false
        saveSuccess = false
    }
}
