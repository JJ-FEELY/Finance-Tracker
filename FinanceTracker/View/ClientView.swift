//
//  ClientView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import SwiftUI

struct ClientView: View {
    @ObservedObject var viewModel: ClientViewModel
    
    @Binding var path: [routes]
    
    var body: some View {
        ScrollView{
            Text("Hello Clients")
        }
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


