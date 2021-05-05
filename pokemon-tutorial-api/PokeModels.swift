//
//  PokeModels.swift
//  pokemon-tutorial-api
//
//  Created by Maegan Wilson on 5/5/21.
//

import Foundation

struct APIResult: Codable {
    var name: String
    var url: String
}

struct PokeCallResult: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [APIResult]
}
