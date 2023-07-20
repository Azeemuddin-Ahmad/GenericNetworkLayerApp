//
//  ExampleRequest.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 19/07/2023.
//

import Foundation
import Alamofire

enum URLConstant: String {
    case live = "https://api.github.com"
    
    func getBaseURL() -> URL {
        return URL(string: rawValue)!
    }
}

final class ExampleRequest: RequestBuilderProtocol {
    
    fileprivate let requestNM: ExampleRequestNM
    
    init(requestNM: ExampleRequestNM) {
        self.requestNM = requestNM
    }
    
    var baseURL: URL {
        return URLConstant.live.getBaseURL()
    }
    
    var endPoint: String {
        return "/search/users"
    }
    
    var params: Parameters? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(requestNM)
            
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var encoding: Alamofire.ParameterEncoding {
        return URLEncoding.default
    }
}
