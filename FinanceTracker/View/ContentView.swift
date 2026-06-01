//
//  ContentView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 28/05/2026.
//

import SwiftUI
import SwiftData
import Charts

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: ContentViewModel

    @Query(sort: \Transaction.date, order: .reverse)
    private var transactions: [Transaction]

    private var income: Decimal {
        transactions.filter { $0.type == .income }
            .reduce(Decimal(0)) { $0 + $1.amount }
    }

    private var expenses: Decimal {
        transactions.filter { $0.type == .expense }
            .reduce(Decimal(0)) { $0 + $1.amount }
    }

    private var netProfit: Decimal { income - expenses }

    private struct CategorySpend: Identifiable {
        let category: Category
        let total: Decimal
        var id: UUID { category.id }
    }

    private var categorySpending: [CategorySpend] {
        let expenseTxs = transactions.filter { $0.type == .expense && $0.category != nil }
        let grouped = Dictionary(grouping: expenseTxs) { $0.category! }
        return grouped
            .map { CategorySpend(category: $0.key,
                                 total: $0.value.reduce(Decimal(0)) { $0 + $1.amount }) }
            .sorted { $0.total > $1.total }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                heroTotal
                splitCards
                if !categorySpending.isEmpty { categoryChart }
                recentTransactions
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Dashboard")
    }

    private var heroTotal: some View {
        VStack(spacing: 4) {
            Text("Net Profit")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(netProfit, format: .currency(code: "GBP"))
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(netProfit >= 0 ? Color.primary : Color.red)
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }

    private var splitCards: some View {
        HStack(spacing: 12) {
            StatCard(title: "Income",
                     amount: income,
                     color: .green,
                     icon: "arrow.down.left.circle.fill")
            StatCard(title: "Expenses",
                     amount: expenses,
                     color: .red,
                     icon: "arrow.up.right.circle.fill")
        }
    }

    private var categoryChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spending by Category")
                .font(.headline)

            Chart(categorySpending) { item in
                SectorMark(
                    angle: .value("Amount", item.total),
                    innerRadius: .ratio(0.6),
                    angularInset: 1.5
                )
                .foregroundStyle(Color(hex: item.category.colorHex))
                .cornerRadius(4)
            }
            .frame(height: 220)

            VStack(spacing: 8) {
                ForEach(categorySpending) { item in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(Color(hex: item.category.colorHex))
                            .frame(width: 10, height: 10)
                        Text(item.category.name)
                            .font(.subheadline)
                        Spacer()
                        Text(item.total, format: .currency(code: "GBP"))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var recentTransactions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Transactions")
                .font(.headline)

            if transactions.isEmpty {
                Text("No transactions yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            } else {
                let recent = Array(transactions.prefix(5))
                ForEach(Array(recent.enumerated()), id: \.element.id) { index, tx in
                    TransactionRow(transaction: tx)
                    if index < recent.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

private struct StatCard: View {
    let title: String
    let amount: Decimal
    let color: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(amount, format: .currency(code: "GBP"))
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

private struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            iconBadge
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.subheadline.weight(.medium))
                Text(transaction.date, format: .dateTime.day().month().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(signedAmount, format: .currency(code: "GBP"))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(transaction.type == .income ? .green : .red)
        }
        .padding(.vertical, 4)
    }

    private var signedAmount: Decimal {
        transaction.type == .income ? transaction.amount : -transaction.amount
    }

    @ViewBuilder
    private var iconBadge: some View {
        if let category = transaction.category {
            Image(systemName: category.icon)
                .foregroundStyle(Color(hex: category.colorHex))
                .frame(width: 32, height: 32)
                .background(Color(hex: category.colorHex).opacity(0.15))
                .clipShape(Circle())
        } else {
            Image(systemName: "circle.dashed")
                .foregroundStyle(.secondary)
                .frame(width: 32, height: 32)
        }
    }
}

private extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
