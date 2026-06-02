//
//  ClientView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import SwiftUI
import SwiftData

struct ClientView: View {
    @ObservedObject var viewModel: ClientViewModel
    
    @Binding var path: [routes]
    
    @Query(sort: \Client.firstName) private var clients: [Client]
    
    @State private var search: String = ""
    
    private var filtered: [Client] {
        guard !search.isEmpty else { return clients }
        return clients.filter { $0.firstName.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        Group {
            if filtered.isEmpty {
                ContentUnavailableView(
                    search.isEmpty ? "No Clients" : "No Results",
                    systemImage: search.isEmpty ? "person.3" : "magnifyingglass",
                    description: Text(search.isEmpty
                        ? "Tap + to add your first client."
                        : "No clients match \"\(search)\".")
                )
            } else {
                List(filtered) { client in
                    HStack{
                        Text("\(client.firstName) \(client.lastName)")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    .onTapGesture {
                        path.append(.clientDetails(id: client.id))
                    }
                }
            }
        }
        .searchable(text: $search)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    path.append(.addClient)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}


