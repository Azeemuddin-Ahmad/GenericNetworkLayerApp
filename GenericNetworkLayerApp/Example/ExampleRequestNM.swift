//
//  ExampleRequestNM.swift
//  GenericNetworkLayerApp
//
//  Created by Azeemuddin Ahmad on 19/07/2023.
//

import Foundation

struct ExampleRequestNM: Codable {
    var page: String
    var perPageLimit: String
    var searchQuery: String
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPageLimit = "per_page"
        case searchQuery = "q"
    }
}
