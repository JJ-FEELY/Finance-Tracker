//
//  AddClientView.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//
import SwiftUI

struct AddClientView: View {
    @ObservedObject var viewModel: AddClientViewModel
    @Binding var path: [routes]
    
    var body: some View {
        Form {
            Section() {
                HStack{
                    TextField("First name", text: $viewModel.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Last name", text: $viewModel.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                
                TextField("Phone number", text: $viewModel.phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack{
                    Spacer()
                    Button("Create"){
                        viewModel.saveClient()
                    }
                }
            }
        }
        .onChange(of: viewModel.saveSuccess) {
            path.removeLast()
        }
        .navigationBarTitle("Create client")
    }
}
