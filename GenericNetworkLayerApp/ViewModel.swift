//
//  ViewModel.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 19/07/2023.
//

import Foundation
import Combine

final class ViewModel {
    private var networkService: NetworkService
    private var subscriptions: [AnyCancellable] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func makeRequest() {
        networkService.searchUsers(page: "0", perPageLimit: "9", searchQuery: "test").sink { completion in
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
}
