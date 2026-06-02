//
//  AddClientViewModel.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import Foundation
import Combine
import SwiftData

class AddClientViewModel: ObservableObject{
    
    private let context = PersistenceController.shared.context
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    @Published var saveSuccess: Bool = false
        
    func saveClient() {

        let newClient =
        Client(
            id: UUID(),
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            email: email
        )
        context.insert(newClient)
        
        do{
            try context.save()
           
            saveSuccess = true
            
            clearForm()
        }catch{
            print(error)
        }
    }
    
    func clearForm(){
        firstName = ""
        lastName = ""
        email = ""
        phoneNumber = ""
        saveSuccess = false
    }
}
