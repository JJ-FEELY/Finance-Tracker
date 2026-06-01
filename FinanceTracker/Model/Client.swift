//
//  Client.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import Foundation
import SwiftData

@Model
class Client {
    var id: UUID
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    
    @Relationship(deleteRule: .nullify)
    var transactions: [Transaction]?
    
    init(id: UUID, firstName: String, lastName: String, phoneNumber: String, email: String, transactions: [Transaction]? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.transactions = transactions
    }
}
