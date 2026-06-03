//
//  TaxViewModel.swift
//  FinanceTracker
//
//  Created by Michael Feely on 03/06/2026.
//
import Foundation
import Combine
import SwiftData

class TaxViewModel: ObservableObject {
    
    private let context = PersistenceController.shared.context
    
    @Published var settings: TaxSettings?
    @Published var transactions: [Transaction] = []
    
    var totalTaxOwed: Decimal {
        TaxHelper.taxOwed(on: totalGrossIncome)  // ✅ bands applied automatically
    }

    var effectiveRate: Decimal {
        TaxHelper.effectiveTaxRate(on: totalGrossIncome)
    }

    var taxBreakdown: [TaxBand] {
        TaxHelper.taxBreakdown(on: totalGrossIncome)
    }

    
    var taxYear: Int {
        TaxHelper.currentTaxYear()
    }
    
    var yearStart: Date {
        TaxHelper.taxYearStart(for: taxYear)
    }
    
    var yearEnd: Date {
        TaxHelper.taxYearEnd(for: taxYear)
    }
    
    /// All business income in current tax year
    var totalGrossIncome: Decimal {
        transactions
            .filter {
                $0.type == .income &&
                $0.transactionScope == .business &&
                $0.date >= yearStart &&
                $0.date <= yearEnd
            }
            .reduce(Decimal(0)) { $0 + $1.amount }
    }
    
    var netIncome: Decimal {
        totalGrossIncome - totalTaxOwed
    }
    
    var quarterlyBreakdown: [(name: String, income: Decimal, taxOwed: Decimal)] {
        let annualEffectiveRate = TaxHelper.effectiveTaxRate(on: totalGrossIncome)
        
        return TaxHelper.quarters(for: taxYear).map { quarter in
            let income = transactions
                .filter {
                    $0.type == .income &&
                    $0.transactionScope == .business &&
                    $0.date >= quarter.start &&
                    $0.date <= quarter.end
                }
                .reduce(Decimal(0)) { $0 + $1.amount }
            
            return (
                name: quarter.name,
                income: income,
                taxOwed: income * annualEffectiveRate
            )
        }
    }

    // MARK: - Actions
    
    func updateTaxRate(_ rate: Decimal) {
        settings?.taxRate = rate
        try? context.save()
    }
    
    func fetchData() {
        let descriptor = FetchDescriptor<Transaction>()
        transactions = (try? context.fetch(descriptor)) ?? []
        
        let settingsDescriptor = FetchDescriptor<TaxSettings>()
        if let existing = try? context.fetch(settingsDescriptor).first {
            settings = existing
        } else {
            let newSettings = TaxSettings(taxRate: 0.20)
            context.insert(newSettings)
            try? context.save()
            settings = newSettings
        }
    }
}
