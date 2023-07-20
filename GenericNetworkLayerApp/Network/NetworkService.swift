//
//  NetworkService.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 19/07/2023.
//

import Foundation
import Alamofire
import Combine

protocol NetworkServiceProtocol {
    func performRequest<T: Codable>(_ request: RequestBuilderProtocol, responseModel: T.Type) -> AnyPublisher<T, AFError>
}

extension NetworkServiceProtocol {
    
    func performRequest<T: Codable>(_ request: RequestBuilderProtocol, responseModel: T.Type) -> AnyPublisher<T, AFError> {
        let requestPublisher = AF.request(request).publishDecodable(type: T.self)
        
        return requestPublisher.value().mapError { error in
            return error
        }.eraseToAnyPublisher()

//            return Future<T, AFError> { promise in
//                let cancellable = requestPublisher.sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break // Not needed, since Future will automatically complete when the sink is deallocated
//                    case .failure(let error):
//                        print("Error: \(error)")
//                        promise(.failure(error.asAFError(orFailWith: "Unable to cast to AFError")))
////                        promise(.failure(error))
//                    }
//                }, receiveValue: { result in
//                    print("Result: \(result)")
//                    if let value = result.value {
//                        print("Result: \(value)")
//                        promise(.success(value))
//                    } else if let error = result.error {
//                        print("Error: \(error)")
//                        promise(.failure(error))
//                    }
//                })
//            }
        
        
//        return Future<T, AFError> { promise in
//            let request = AF.request(request)
//            let requestPublisher = request.publishDecodable(type: T.self)
//            let a = requestPublisher.sink { result in
//                if let value = result.value {
//                    print("Result: \(value)")
//                    promise(.success(value))
//                } else if let error = result.error {
//                    print("Error: \(error)")
//                    promise(.failure(error))
//                }
//            }
//        }
    }
}

final class NetworkService: NetworkServiceProtocol {
    
    var subscriptions = [AnyCancellable]()
    
    func searchUsers(page: String, perPageLimit: String, searchQuery: String) -> Future<ExampleResponseNM, AFError> {
        let request = ExampleRequest(requestNM: ExampleRequestNM(page: page, perPageLimit: perPageLimit, searchQuery: searchQuery))
        
        return Future<ExampleResponseNM, AFError> { [weak self] promise in
            guard let strongSelf = self else {
//                promise(.failure(.explicitlyCancelled))
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
}

