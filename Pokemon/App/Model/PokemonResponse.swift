//
//  PokemonResponse.swift
//  Pokemon
//
//  Created by Diggo Silva on 18/04/24.
//

import Foundation

// MARK: PokemonResponse
struct PokemonResponse: Codable {
    let name: String
    let url: String
    let id: Int?
    let height: Int?
    let weight: Int?
    let experience: Int?
    let image: String
}

// MARK: Pokemon
struct Pokemon {
    let name: String
    let height: Int
    let weight: Int
    let experience: Int
    let id: Int
    let image: String
}
