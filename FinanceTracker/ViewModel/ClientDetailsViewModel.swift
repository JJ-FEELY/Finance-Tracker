//
//  ClientDetailsViewModel.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import Foundation
import Combine
import SwiftData

class ClientDetailsViewModel: ObservableObject{
    
    private let context = PersistenceController.shared.context
    let id: UUID
    
    @Published var client: Client?
    
    init(id: UUID) {
        self.id = id
        fetchClient()
    }
    
    func deleteClient(){
        let id = self.id
        
        let descriptor = FetchDescriptor<Client>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let client = try? context.fetch(descriptor).first else { return }
        context.delete(client)
        try? context.save()
    }
    
    func fetchClient(){
        let id = self.id
        
        let descriptor = FetchDescriptor<Client>(
            predicate: #Predicate { $0.id == id }
        )
        
        client = try? context.fetch(descriptor).first

    }
    
        
}
