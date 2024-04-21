//
//  PokemonNameBackEnd.swift
//  Pokemon
//
//  Created by Diggo Silva on 18/04/24.
//

import Foundation

// MARK: PokemonNameBackEnd
struct PokemonResponse: Codable {
    let results: [Result]
}

struct Result: Codable {
    let name: String
    let url: String
}

// MARK: PokemonImageBackEnd
struct PokemonImageBackEnd: Codable {
    let height: Int
    let weight: Int
    let baseExperience: Int
    let id: Int
    let sprites: Sprites
    
    enum CodingKeys: String, CodingKey {
        case height
        case weight
        case baseExperience = "base_experience"
        case id
        case sprites
    }
}

struct Sprites: Codable {
    let other: Other
}

struct Other: Codable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
