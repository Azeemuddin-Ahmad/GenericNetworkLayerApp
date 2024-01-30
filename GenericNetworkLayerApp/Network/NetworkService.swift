//
//  NetworkService.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 19/07/2023.
//

import Foundation
import Alamofire
import Combine

enum APIError: Error {
    // Your custom error cases here
    case requestFailed
}

/// A protocol representing a service that handles networking operations.
protocol NetworkService {
    func performRequest<T: Codable>(_ request: RequestBuilderProtocol, responseModel: T.Type) -> AnyPublisher<T, AFError>
    
    func performDownloadRequest(_ url: URL, fileName: String) -> AnyPublisher<Data, AFError>
}

extension NetworkService {
    
    func performRequest<T: Codable>(_ request: RequestBuilderProtocol, responseModel: T.Type) -> AnyPublisher<T, AFError> {
        let requestPublisher = AF.request(request).validate().publishDecodable(type: T.self)
        
        return requestPublisher.value().mapError { error in
            return error
        }.eraseToAnyPublisher()
    }
    
    func performDownloadRequest(_ url: URL, fileName: String) -> AnyPublisher<Data, AFError> {
        let downloadsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let downloadDir = downloadsURL.appendingPathComponent("\(fileName).m3u8")
        
        let requestPublisher = AF.download(url, to: { _, _ in
            return (downloadDir, [.removePreviousFile])
        }).validate().downloadProgress { progress in
            print("Progress: \(progress)")
        }.publishData()
        
        
        return requestPublisher.value().mapError { error in
            return error
        }.eraseToAnyPublisher()
    }
}

/// A protocol representing a service that handles caching operations.
protocol CacheService { }


