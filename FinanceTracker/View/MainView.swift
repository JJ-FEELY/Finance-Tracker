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
}
struct MainView: View {
    @StateObject private var clientVM = ClientViewModel()
    @StateObject private var contentVM = ContentViewModel()
    
    @State var clientRoute: [routes]  = []
    
    var body: some View {
        
        TabView{
            
            Tab("Dashboard", systemImage: "chart.bar") {
                NavigationStack(){ ContentView(viewModel: contentVM)}
            }
            
            Tab("Transactions", systemImage: "list.bullet") {
                NavigationStack{ TransactionView()}
            }
            
            Tab("Clients", systemImage: "person.3") {
                NavigationStack(path: $clientRoute){
                    ClientView(viewModel: clientVM, path: $clientRoute)
                        .navigationDestination(for: routes.self) { route in
                            switch route {
                            case .addClient:
                                AddClientView()
                                    .toolbar(.hidden, for: .tabBar)
                            case .clientDetails(let id):
                                Text("Client \(id)")
                            }
                        }
                }
                
            }
        }
    }
}
