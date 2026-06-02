//
//  Transaction.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import Foundation
import SwiftData

@Model
class Transaction: Identifiable {
    var id: UUID
    var title: String
    var amount: Decimal
    var type: TransactionType
    var transactionScope: TransactionScope
    var date: Date
    var note: String?
    var isReccuring: Bool
    

    @Relationship var category: Category?
    @Relationship var client: Client?

    init(id: UUID, title: String, amount: Decimal, type: TransactionType, transactionScope: TransactionScope, date: Date, note: String? = nil, isReccuring: Bool) {
        self.id = id
        self.title = title
        self.amount = amount
        self.type = type
        self.transactionScope = transactionScope
        self.date = date
        self.note = note
        self.isReccuring = false
    }
}

enum TransactionScope: String, Codable {
    case business
    case personal
}

enum TransactionType: String, Codable {
    case income
    case expense
}
