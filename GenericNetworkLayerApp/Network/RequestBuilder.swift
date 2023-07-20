//
//  APIRequest.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 19/07/2023.
//

import Foundation
import Alamofire

protocol RequestBuilderProtocol: URLRequestConvertible {
    var baseURL: URL { get }
    var requestURL: URL { get }
    var endPoint: String { get }
    var params: Parameters? { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders { get }
    var urlRequest: URLRequest { get }
}

extension RequestBuilderProtocol {
    
    var requestURL: URL {
        baseURL.appending(path: endPoint)
    }
    
    var params: [String: Any]? {
        return nil
    }
    
    var headers: HTTPHeaders {
        return defaultJSONHeaders()
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        return request
    }
    
    func defaultJSONHeaders() -> HTTPHeaders {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "NULL"
        return [
            "Content-Type": "application/json",
            "User-Agent" : "iOS \(UIDevice.current.systemVersion) \(UIDevice.current.name) PL: \(appVersion)"
        ]
    }
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: params)
    }
}
