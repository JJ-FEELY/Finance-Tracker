//
//  TransactionView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import SwiftUI
import SwiftData

struct TransactionView: View {
    @Binding var path: [routes]
    
    @Query(sort: \Transaction.title) private var transaction: [Transaction]
    
    @State private var search: String = ""
    
    private var filtered: [Transaction] {
        guard !search.isEmpty else { return transaction }
        return transaction.filter { $0.title.localizedCaseInsensitiveContains(search) }
    }
    
    var body: some View {
        Group {
            if filtered.isEmpty {
                ContentUnavailableView(
                    search.isEmpty ? "No Transactions" : "No Results",
                    systemImage: search.isEmpty ? "arrow.left.arrow.right" : "magnifyingglass",
                    description: Text(search.isEmpty
                        ? "Tap + to add your first transaction."
                        : "No clients match \"\(search)\".")
                )
            } else {
                List(filtered) { transaction in
                    HStack{
                        Text("\(transaction.title)")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .onTapGesture {
                        path.append(.transactionDetails(transaction))
                    }
                }
            }
        }
        .searchable(text: $search)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    path.append(.addTransaction)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}


