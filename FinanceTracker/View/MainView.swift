//
//  MainView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import SwiftUI
import SwiftData
enum routes: Hashable {
    case addClient
    case clientDetails(id: UUID)
    case addTransaction
    case transactionDetails(Transaction)
    
}
struct MainView: View {
    @StateObject private var clientVM = ClientViewModel()
    @StateObject private var contentVM = ContentViewModel()
   
    
    @State var clientRoute: [routes]  = []
    @State var transactionRoute: [routes]  = []
    
    var body: some View {
        
        TabView{
            
            Tab("Dashboard", systemImage: "chart.bar") {
                NavigationStack(){ ContentView(viewModel: contentVM)}
            }
            
            Tab("Transactions", systemImage: "list.bullet") {
                NavigationStack(path: $transactionRoute){
                    TransactionView(path: $transactionRoute)
                        .navigationDestination(for: routes.self) { route in
                            switch route {
                            case .addTransaction:
                                AddTransactionView(viewModel: AddTransactionViewModel(), path: $transactionRoute)
                                    .toolbar(.hidden, for: .tabBar)
                            case .transactionDetails(let transaction):
                                TransactionDetailsView(transaction: transaction, path: $transactionRoute)
                                    .toolbar(.hidden, for: .tabBar)
                            default:
                                EmptyView()
                            }
                        }
                }
            }
            
            Tab("Tax", systemImage: "percent") {
                NavigationStack(){ TaxView(viewModel: TaxViewModel())}
            }

            
            Tab("Clients", systemImage: "person.3") {
                NavigationStack(path: $clientRoute){
                    ClientView(viewModel: clientVM, path: $clientRoute)
                        .navigationDestination(for: routes.self) { route in
                            switch route {
                            case .addClient:
                                AddClientView(viewModel: AddClientViewModel(), path: $clientRoute)
                                    .toolbar(.hidden, for: .tabBar)
                            case .clientDetails(let id):
                                ClientDetailsView(viewModel: ClientDetailsViewModel(id: id), path: $clientRoute)
                                    .toolbar(.hidden, for: .tabBar)
                            default:
                                EmptyView()
                            
                            }
                        }
                }
                
            }
        }
    }
}
