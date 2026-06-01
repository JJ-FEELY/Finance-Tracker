//
//  Category.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import Foundation
import SwiftData

@Model
class Category {
    var id: UUID
    var name: String
    var colorHex: String
    var icon: String
    
    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction]?
    
    init(name: String, colorHex: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
        self.icon = icon
    }
}
extension Category {
    static let defaults: [Category] = [
        Category(name: "Food",        colorHex: "#FF6B6B", icon: "cart.fill"),
        Category(name: "Transport",   colorHex: "#4ECDC4", icon: "car.fill"),
        Category(name: "Housing",     colorHex: "#45B7D1", icon: "house.fill"),
        Category(name: "Healthcare",  colorHex: "#96CEB4", icon: "heart.fill"),
        Category(name: "Salary",      colorHex: "#88D8B0", icon: "banknote.fill"),
        Category(name: "Shopping",    colorHex: "#FFEAA7", icon: "bag.fill"),
        Category(name: "Savings",     colorHex: "#DDA0DD", icon: "building.columns.fill")
    ]
}
