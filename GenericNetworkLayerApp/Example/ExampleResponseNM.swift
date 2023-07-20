//
//  ExampleResponse.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 19/07/2023.
//

import Foundation

struct ExampleResponseNM: Codable {
    var count: Int?
    var result: Bool?
    var items: [Item]?
    
    enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case result = "incomplete_results"
        case items
    }
}

struct Item: Codable {
    var login: String
    var url: String
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case url = "avatar_url"
        case type
    }
}
