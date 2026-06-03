//
//  AddClientViewModel.swift
//  FinanceTracker
//
//  Created by Michael Feely on 01/06/2026.
//

import Testing
import Foundation
import SwiftData
@testable import FinanceTracker

@MainActor
struct AddClientViewModelTests {

    @Test
    func initialState_isEmptyAndNotSaved() {
        let vm = AddClientViewModel()

        #expect(vm.firstName == "")
        #expect(vm.lastName == "")
        #expect(vm.email == "")
        #expect(vm.phoneNumber == "")
        #expect(vm.saveSuccess == false)
    }

    @Test
    func clearForm_resetsAllFieldsAndSaveSuccess() {
        let vm = AddClientViewModel()
        vm.firstName = "Justin"
        vm.lastName = "Feely"
        vm.email = "justin@example.com"
        vm.phoneNumber = "07000 000000"
        vm.saveSuccess = true

        vm.clearForm()

        #expect(vm.firstName == "")
        #expect(vm.lastName == "")
        #expect(vm.email == "")
        #expect(vm.phoneNumber == "")
        #expect(vm.saveSuccess == false)
    }

    @Test
    func saveClient_clearsFormFieldsAfterSuccessfulSave() throws {
        let vm = AddClientViewModel()
        let marker = "Cleanup-\(UUID().uuidString)"
        vm.firstName = marker
        vm.lastName = "Test"
        vm.email = "x@y.com"
        vm.phoneNumber = "0000"

        vm.saveClient()

        #expect(vm.firstName == "")
        #expect(vm.lastName == "")
        #expect(vm.email == "")
        #expect(vm.phoneNumber == "")

        try removeClients(firstName: marker)
    }

    @Test
    func saveClient_persistsClientWithEnteredDetails() throws {
        let vm = AddClientViewModel()
        let marker = "First-\(UUID().uuidString)"
        vm.firstName = marker
        vm.lastName = "Last"
        vm.email = "persist@example.com"
        vm.phoneNumber = "07111 111111"

        vm.saveClient()

        let saved = try fetchClients(firstName: marker)
        #expect(saved.count == 1)
        #expect(saved.first?.lastName == "Last")
        #expect(saved.first?.email == "persist@example.com")
        #expect(saved.first?.phoneNumber == "07111 111111")

        try removeClients(firstName: marker)
    }

    @Test
    func saveClient_canBeCalledMultipleTimesForMultipleClients() throws {
        let vm = AddClientViewModel()
        let markerA = "MultiA-\(UUID().uuidString)"
        let markerB = "MultiB-\(UUID().uuidString)"

        vm.firstName = markerA
        vm.lastName = "A"
        vm.email = "a@example.com"
        vm.phoneNumber = "0001"
        vm.saveClient()

        vm.firstName = markerB
        vm.lastName = "B"
        vm.email = "b@example.com"
        vm.phoneNumber = "0002"
        vm.saveClient()

        let savedA = try fetchClients(firstName: markerA)
        let savedB = try fetchClients(firstName: markerB)
        #expect(savedA.count == 1)
        #expect(savedB.count == 1)

        try removeClients(firstName: markerA)
        try removeClients(firstName: markerB)
    }


    private func fetchClients(firstName: String) throws -> [Client] {
        let context = PersistenceController.shared.context
        let target = firstName
        let descriptor = FetchDescriptor<Client>(
            predicate: #Predicate { $0.firstName == target }
        )
        return try context.fetch(descriptor)
    }

    private func removeClients(firstName: String) throws {
        let context = PersistenceController.shared.context
        for client in try fetchClients(firstName: firstName) {
            context.delete(client)
        }
        try context.save()
    }
}
