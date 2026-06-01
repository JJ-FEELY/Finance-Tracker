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
    var name: String
    var colorHex: String
    
    @Relationship(deleteRule: .nullify)
    var transactions: [Transaction]?
    
    init(name: String, colorHex: String) {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
    }
}
