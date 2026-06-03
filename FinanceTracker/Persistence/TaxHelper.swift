//
//  TaxHelper.swift
//  FinanceTracker
//
//  Created by Michael Feely on 03/06/2026.
//


import Foundation

struct TaxBand: Identifiable {
    let id = UUID()
    let name: String
    let income: Decimal
    let rate: Decimal
    let tax: Decimal
}

struct TaxHelper {
    
    private static let personalAllowance: Decimal = 12_570
    private static let basicRateLimit: Decimal = 50_270     // personal allowance + basic rate band
    private static let basicRate: Decimal = 0.20
    private static let higherRate: Decimal = 0.40
    
    static func taxOwed(on grossIncome: Decimal) -> Decimal {
        var tax: Decimal = 0
        
        // Under personal allowance — no tax
        guard grossIncome > personalAllowance else { return 0 }
        
        // Basic rate band — 20% on £12,571 to £50,270
        let basicRatePortion = min(grossIncome, basicRateLimit) - personalAllowance
        tax += basicRatePortion * basicRate
        
        // Higher rate band — 40% on everything above £50,270
        if grossIncome > basicRateLimit {
            let higherRatePortion = grossIncome - basicRateLimit
            tax += higherRatePortion * higherRate
        }
        
        return tax
    }
    
    
    static func effectiveTaxRate(on grossIncome: Decimal) -> Decimal {
        guard grossIncome > 0 else { return 0 }
        return taxOwed(on: grossIncome) / grossIncome
    }
    
    
    static func taxBreakdown(on grossIncome: Decimal) -> [TaxBand] {
        var bands: [TaxBand] = []
        
        // Personal Allowance
        let allowance = min(grossIncome, personalAllowance)
        bands.append(TaxBand(
            name: "Personal Allowance",
            income: allowance,
            rate: 0,
            tax: 0
        ))
        
        guard grossIncome > personalAllowance else { return bands }
        
        // Basic Rate
        let basicIncome = min(grossIncome, basicRateLimit) - personalAllowance
        bands.append(TaxBand(
            name: "Basic Rate (20%)",
            income: basicIncome,
            rate: basicRate,
            tax: basicIncome * basicRate
        ))
        
        guard grossIncome > basicRateLimit else { return bands }
        
        // Higher Rate
        let higherIncome = grossIncome - basicRateLimit
        bands.append(TaxBand(
            name: "Higher Rate (40%)",
            income: higherIncome,
            rate: higherRate,
            tax: higherIncome * higherRate
        ))
        
        return bands
    }
    // UK tax year runs April 6 to April 5
    
    static func currentTaxYear() -> Int {
        let month = Calendar.current.component(.month, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        return month >= 4 ? year : year - 1
    }
    
    static func taxYearStart(for year: Int) -> Date {
        Calendar.current.date(from: DateComponents(
            year: year, month: 4, day: 6
        ))!
    }
    
    static func taxYearEnd(for year: Int) -> Date {
        Calendar.current.date(from: DateComponents(
            year: year + 1, month: 4, day: 5
        ))!
    }
    
    static func quarters(for taxYear: Int) -> [(name: String, start: Date, end: Date)] {
        [
            (
                name: "Q1",
                start: dateFrom(day: 6, month: 4, year: taxYear),
                end: dateFrom(day: 5, month: 7, year: taxYear)
            ),
            (
                name: "Q2",
                start: dateFrom(day: 6, month: 7, year: taxYear),
                end: dateFrom(day: 5, month: 10, year: taxYear)
            ),
            (
                name: "Q3",
                start: dateFrom(day: 6, month: 10, year: taxYear),
                end: dateFrom(day: 5, month: 1, year: taxYear + 1)
            ),
            (
                name: "Q4",
                start: dateFrom(day: 6, month: 1, year: taxYear + 1),
                end: dateFrom(day: 5, month: 4, year: taxYear + 1)
            )
        ]
    }
    
    static func taxOwed(on income: Decimal, rate: Decimal) -> Decimal {
        return income * rate
    }
    
    static func netIncome(gross: Decimal, taxRate: Decimal) -> Decimal {
        return gross - taxOwed(on: gross, rate: taxRate)
    }
    
    
    private static func dateFrom(day: Int, month: Int, year: Int) -> Date {
        Calendar.current.date(from: DateComponents(
            year: year, month: month, day: day
        ))!
    }
}
