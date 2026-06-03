//
//  AddTransactionView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import SwiftUI
import SwiftData
struct AddTransactionView: View {
    @ObservedObject var viewModel: AddTransactionViewModel
    @Binding var path: [routes]
    
    @Query(sort: \Client.id) private var clients: [Client]
    @Query(sort: \Category.name) private var category: [Category]
    
    @State var showError: Bool = false
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Title*", text: $viewModel.title)
                TextField("Amount*", value: $viewModel.amount, format: .currency(code: "GBP"))
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
            }
            
            Section("Type") {
                Picker("Type", selection: $viewModel.transactionType) {
                    Text("Income").tag(TransactionType.income)
                    Text("Expense").tag(TransactionType.expense)
                }
                .pickerStyle(.segmented)

                Picker("Scope", selection: $viewModel.transactionScope) {
                    Text("Business").tag(TransactionScope.business)
                    Text("Personal").tag(TransactionScope.personal)
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                Toggle("Recurring", isOn: $viewModel.isReccuring)
            }

            Picker("Category", selection: $viewModel.selectedCategory) {
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
            
            
            Picker("Client", selection: $viewModel.selectedClient) {
                Text("None").tag(nil as Client?)
                ForEach(clients) { client in
                    Text("\(client.firstName) \(client.lastName)").tag(client as Client?)
                }
            }
            if showError == true{
                Text(("Please ensure all required fields are filled out"))
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            Section {
                
                Button("Create") {
                    if !viewModel.isFormValid{
                        showError = true
                    }else{
                        viewModel.saveTransaction()
                    }
                }
            }
            
            


        }
        .onChange(of: viewModel.saveSuccess) {
            path.removeLast()
        }
        .navigationBarTitle("Add transaction")
    }
}
