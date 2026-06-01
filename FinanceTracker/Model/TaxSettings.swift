//
//  TaxSettings.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import Foundation
import SwiftData

@Model
class TaxSettings {
    var id: UUID
    var taxRate: Decimal        // e.g 0.20 for 20%
    var taxPotTotal: Decimal    // running total set aside
    
    init(taxRate: Decimal) {
        self.id = UUID()
        self.taxRate = taxRate
        self.taxPotTotal = 0
    }
}
