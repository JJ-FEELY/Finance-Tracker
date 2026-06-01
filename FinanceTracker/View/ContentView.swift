//
//  ContentView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 28/05/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: ContentViewModel

    @Query private var businessIncome: [Transaction]
    @Query private var businessExpenses: [Transaction]

    init(viewModel: ContentViewModel) {
        let incomeType = TransactionType.income
        let expenseType = TransactionType.expense
        let businessScope = TransactionScope.business

        let incomePredicate = #Predicate<Transaction> { transaction in
            transaction.type == incomeType && transaction.transactionScope == businessScope
        }
        let expensePredicate = #Predicate<Transaction> { transaction in
            transaction.type == expenseType && transaction.transactionScope == businessScope
        }

        _businessIncome = Query(filter: incomePredicate, sort: \.date, order: .reverse)
        _businessExpenses = Query(filter: expensePredicate)

        self.viewModel = viewModel
    }
    
    var netProfit: Decimal {
        let income = businessIncome.reduce(Decimal(0)) { $0 + $1.amount }
        let expenses = businessExpenses.reduce(Decimal(0)) { $0 + $1.amount }
        return income - expenses
    }
    
    
    var body: some View {
        ScrollView{
            Text("This Month")
                .font(.caption)
                .foregroundStyle(.gray)
            Text("£\(netProfit)")
                .font(Font.largeTitle)
                .fontWeight(.semibold)
        }
    }
}

