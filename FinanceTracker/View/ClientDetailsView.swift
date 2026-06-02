//
//  ClientDetailsView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import SwiftUI

struct ClientDetailsView: View {
    @ObservedObject var viewModel: ClientDetailsViewModel
    @State private var isEditing: Bool = false
    @State private var showDeleteConfirmation = false
    
    @Binding var path: [routes]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(viewModel.client?.firstName ?? "No first name") \(viewModel.client?.lastName ?? "No last name")")
                .font(Font.title.bold())
            
            Text(viewModel.client?.phoneNumber ?? "No phone number")
            
            Text(viewModel.client?.email ?? "No email")
                .padding(.bottom, 8)
            
            Divider()
                .padding(.vertical, 4)
            Text("Recent transactions")
                .fontWeight(.semibold)
            
            

            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 14)
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
            "Delete this client?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                viewModel.deleteClient()
                path.removeLast()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently remove the client and cannot be undone.")
        }
    }
}
