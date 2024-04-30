//
//  PokemonDetailsResponse.swift
//  Pokemon
//
//  Created by Diggo Silva on 28/04/24.
//

import Foundation

// MARK: PokemonDetailsResponse
struct PokemonDetailsResponse: Codable {
    let height: Int
    let weight: Int
    let baseExperience: Int
    let id: Int
    let forms: [Species]
    let sprites: Sprites
    
    enum CodingKeys: String, CodingKey {
        case height
        case weight
        case baseExperience = "base_experience"
        case id
        case forms
        case sprites
    }
}

struct Species: Codable {
    let name: String
    let url: String
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
