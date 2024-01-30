//
//  Respository.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 30/01/2024.
//

import Foundation
import Alamofire
import Combine

/**
 A protocol representing a repository that combines network and cache functionality.

 A `Repository` acts as an intermediary between the application and the data sources,
 providing methods to interact with data from both network and cache services.
**/
protocol IRepostiory: NetworkService, CacheService { }

final class Repository: IRepostiory {
    
    var subscriptions = [AnyCancellable]()
    
    /// Search Users with Combine
    func searchUsers(page: String, perPageLimit: String, searchQuery: String) -> Future<ExampleResponseNM, AFError> {
        let request = ExampleRequest(requestNM: ExampleRequestNM(page: page, perPageLimit: perPageLimit, searchQuery: searchQuery))
        
        return Future<ExampleResponseNM, AFError> { [weak self] promise in
            guard let strongSelf = self else {
                return
            }
            strongSelf.performRequest(request, responseModel: ExampleResponseNM.self).sink { completion in
                switch completion {
                case .finished:
                    break
                    
                case .failure(let error):
                    print("Error: \(error)")
                    promise(.failure(error))
                }
            } receiveValue: { response in
                print("Response: \(response)")
                promise(.success(response))
                
            }.store(in: &strongSelf.subscriptions)
        }
    }
    
    /// Search Users with Result Enum and Completion Handler
    @available(*, deprecated, renamed: "searchUsers(page:perPageLimit:searchQuery:)")
    func searchUsers(page: String, perPageLimit: String, searchQuery: String, completionHandler: @escaping (Result<ExampleResponseNM, Error>) -> Void)  {
        let request = ExampleRequest(requestNM: ExampleRequestNM(page: page, perPageLimit: perPageLimit, searchQuery: searchQuery))
        
        performRequest(request, responseModel: ExampleResponseNM.self).sink { completion in
            switch completion {
            case .finished:
                break
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        } receiveValue: { response in
            completionHandler(.success(response))
        }.store(in: &subscriptions)
    }
    
    /// Search Users with Async Await
    func searchUsers(page: String, perPageLimit: String, searchQuery: String) async throws -> ExampleResponseNM {
        let request = ExampleRequest(requestNM: ExampleRequestNM(page: page, perPageLimit: perPageLimit, searchQuery: searchQuery))
        
        do {
            if let response = try await performRequest(request, responseModel: ExampleResponseNM.self).values.first(where: { _ in
                return true
            }) {
                return response
            } else {
                throw APIError.requestFailed
            }
        } catch {
            throw error
        }
    }
    
    func downloadVideo(url: URL, videoName: String) -> Future<Data, Never> {
        return Future<Data, Never> { [weak self] promise in
            guard let strongSelf = self else {
                return
            }
            strongSelf.performDownloadRequest(url, fileName: videoName).sink { completion in
               switch completion {
               case .finished:
                   break
                   
               case .failure(let error):
                   print("Error: \(error)")
               }
           } receiveValue: { data in
               print("Response: \(data)")
               promise(.success(data))
               
           }.store(in: &strongSelf.subscriptions)
        }
    }
}
