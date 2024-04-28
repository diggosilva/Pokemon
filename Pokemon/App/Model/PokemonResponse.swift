//
//  PokemonResponse.swift
//  Pokemon
//
//  Created by Diggo Silva on 18/04/24.
//

import Foundation

// MARK: PokemonResponse
struct PokemonResponse: Codable {
    let next: String?
    let results: [Result]
}

struct Result: Codable {
    let name: String
    let url: String
}
