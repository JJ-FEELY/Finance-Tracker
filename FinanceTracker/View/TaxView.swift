//
//  TaxView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 03/06/2026.
//
import SwiftUI

struct TaxView: View {
    
    @ObservedObject var viewModel: TaxViewModel
    @State private var showingRateEditor = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Tax Year Header
                    taxYearHeader
                    
                    taxBandSection
                    // Summary Cards
                    summaryCards
                    
                    // Quarterly Breakdown
                    quarterlySection
                    
                }
                .padding()
            }
            .navigationTitle("Business Tax")
            .onAppear { viewModel.fetchData() }
        }
    }
    
    // MARK: - Subviews
    
    private var taxBandSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tax Breakdown")
                .font(.headline)
            
            ForEach(viewModel.taxBreakdown) { band in
                HStack {
                    VStack(alignment: .leading) {
                        Text(band.name)
                            .font(.subheadline)
                        Text("Income in band: £\(band.income)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("£\(band.tax)")
                        .bold()
                        .foregroundStyle(band.rate == 0 ? .green : .red)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            HStack {
                Text("Effective Rate")
                    .font(.subheadline)
                Spacer()
                Text("\(viewModel.effectiveRate * 100, format: .number.precision(.fractionLength(1)))%")
                    .bold()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var taxYearHeader: some View {
        Text("Tax Year \(viewModel.taxYear)/\(viewModel.taxYear + 1)")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
    
    private var summaryCards: some View {
        VStack(spacing: 12) {
            TaxSummaryCard(
                title: "Gross Income",
                amount: viewModel.totalGrossIncome,
                color: .green
            )
            TaxSummaryCard(
                title: "Tax Owed",
                amount: viewModel.totalTaxOwed,
                color: .red
            )
            TaxSummaryCard(
                title: "Take Home",
                amount: viewModel.netIncome,
                color: .blue
            )
        }
    }
    
    private var quarterlySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quarterly Breakdown")
                .font(.headline)
            
            ForEach(viewModel.quarterlyBreakdown, id: \.name) { quarter in
                HStack {
                   
                    Text(quarter.name)
                        .font(.subheadline)
                        .bold()
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Income: \(quarter.income.formatted(.currency(code: "GBP")))")
                            .font(.subheadline)
                        Text("Tax: \(quarter.taxOwed.formatted(.currency(code: "GBP")))")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    struct TaxSummaryCard: View {
        let title: String
        let amount: Decimal
        let color: Color
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("£\(amount)")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(color)
                }
                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

}
