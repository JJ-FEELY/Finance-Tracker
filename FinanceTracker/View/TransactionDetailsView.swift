//
//  TransactionDetailsView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import SwiftUI
import SwiftData

struct TransactionDetailsView: View {
    let transaction: Transaction
    @Binding var path: [routes]
    @Environment(\.modelContext) private var context
    
    @State private var title: String = ""
    @State private var amount: Decimal = 0
    @State private var date: Date = .now
    @State private var type: TransactionType = .income
    @State private var scope: TransactionScope = .business
    @State private var isRecurring: Bool = false
    @State private var category: Category?
    @State private var client: Client?
    @State private var showError = false
    @State private var showDeleteConfirmation = false
    
    var isFormValid: Bool {
        !title.isEmpty && amount != 0
    }

    
    @Query(sort: \Client.firstName) private var clients: [Client]
    @Query(sort: \Category.name) private var categories: [Category]

    var body: some View {
        Form {
            Section("Details") {
                TextField("Title*", text: $title)
                TextField("Amount*", value: $amount, format: .currency(code: "GBP"))
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }

            Section("Type") {
                Picker("Type", selection: $type) {
                    Text("Income").tag(TransactionType.income)
                    Text("Expense").tag(TransactionType.expense)
                }
                .pickerStyle(.segmented)

                Picker("Scope", selection: $scope) {
                    Text("Business").tag(TransactionScope.business)
                    Text("Personal").tag(TransactionScope.personal)
                }
                .pickerStyle(.segmented)
            }

            Section {
                Toggle("Recurring", isOn: $isRecurring)
            }
            
            Picker("Category", selection: $category) {
                Text("None").tag(nil as Category?)
                ForEach(categories) { category in
                    HStack {
                        Text(category.name)
                        Spacer()
                        Image(systemName: category.icon)
                    }
                    .tag(category as Category?)
                }
            }

            
            Picker("Client", selection: $client) {
                Text("None").tag(nil as Client?)
                ForEach(clients) { client in
                    Text("\(client.firstName) \(client.lastName)")
                        .tag(client as Client?)
                }
            }
            
            if showError == true{
                Text(("Please ensure all required fields are filled out"))
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            Section {
                Button("Save") {
                    if !isFormValid {
                        showError = true
                    } else {
                        transaction.title = title
                        transaction.amount = amount
                        transaction.date = date
                        transaction.type = type
                        transaction.transactionScope = scope
                        transaction.isReccuring = isRecurring
                        transaction.category = category
                        transaction.client = client
                        try? context.save()
                        path.removeLast()
                    }
                }
            }
        }
        .navigationTitle("Edit transaction")
        .onAppear {
            title = transaction.title
            amount = transaction.amount
            date = transaction.date
            type = transaction.type
            scope = transaction.transactionScope
            isRecurring = transaction.isReccuring
            category = transaction.category
            client = transaction.client
        }
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

