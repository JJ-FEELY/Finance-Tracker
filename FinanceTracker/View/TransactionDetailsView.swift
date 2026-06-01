//
//  TransactionDetailsView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import SwiftUI
import SwiftData

struct TransactionDetailsView: View {
    @Bindable var transaction: Transaction
    @Binding var path: [routes]
    @Environment(\.modelContext) private var context
    @State private var showDeleteConfirmation = false

    @Query(sort: \Client.firstName) private var clients: [Client]
    @Query(sort: \Category.name) private var category: [Category]

    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $transaction.title)
                TextField("Amount", value: $transaction.amount, format: .currency(code: "GBP"))
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $transaction.date, displayedComponents: .date)
            }

            Section("Type") {
                Picker("Type", selection: $transaction.type) {
                    Text("Income").tag(TransactionType.income)
                    Text("Expense").tag(TransactionType.expense)
                }
                .pickerStyle(.segmented)

                Picker("Scope", selection: $transaction.transactionScope) {
                    Text("Business").tag(TransactionScope.business)
                    Text("Personal").tag(TransactionScope.personal)
                }
                .pickerStyle(.segmented)
            }

            Section {
                Toggle("Recurring", isOn: $transaction.isReccuring)
            }
            
            Picker("Category", selection: $transaction.category) {
                Text("None").tag(nil as Category?)
                ForEach(category) { category in
                    HStack {
                        Text(category.name)
                        Spacer()
                        Image(systemName: category.icon)
                    }
                    .tag(category as Category?)
                }
            }

            
            Picker("Client", selection: $transaction.client) {
                Text("None").tag(nil as Client?)
                ForEach(clients) { client in
                    Text("\(client.firstName) \(client.lastName)")
                        .tag(client as Client?)
                }
            }

            Section {
                Button("Save") {
                    try? context.save()
                    path.removeLast()
                }
            }
        }
        .navigationTitle("Edit transaction")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.red)
                }
            }
        }
        .confirmationDialog(
            "Delete this transaction?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                context.delete(transaction)
                try? context.save()
                path.removeLast()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently remove the transaction and cannot be undone.")
        }
    }
}

