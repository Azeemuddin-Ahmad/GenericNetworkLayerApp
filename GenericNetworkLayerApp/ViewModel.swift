//
//  ViewModel.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 19/07/2023.
//

import Foundation
import Combine

final class ViewModel {
    private var repository: Repository
    private var subscriptions: [AnyCancellable] = []
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func makeRequestWithCombine() {
        repository.searchUsers(page: "0", perPageLimit: "9", searchQuery: "test").sink { completion in
            switch completion {
            case .finished:
                break
                
            case .failure(let error):
                print("AfError: \(error)")
            }
        } receiveValue: { response in
            print("Future Response: \(response)")
        }.store(in: &subscriptions)
    }
    
    func makeRequestWithAsyncAwait() {
        Task.init {
            do {
                let response = try await repository.searchUsers(page: "0", perPageLimit: "9", searchQuery: "test")
                print("Async Response: \(response)")
            } catch {
                // .. handle error
            }
        }
    }
    
    func makeRequestWithCompletion() {
        repository.searchUsers(page: "0", perPageLimit: "9", searchQuery: "test") { result in
            switch result {
            case .success(let success):
                print("Response: \(success)")
                
            case .failure(let failure):
                print("Response: \(failure)")
            }
        }
    }
}
