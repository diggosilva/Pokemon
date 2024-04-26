//
//  Pokemon.swift
//  Pokemon
//
//  Created by Diggo Silva on 18/04/24.
//

import Foundation

// MARK: Pokemon
struct Pokemon: Equatable {
    let name: String
    let url: String
    let id: Int?
    let height: Int?
    let weight: Int?
    let experience: Int?
    let image: String
    
    var imageURL: String {
        var id = url.components(separatedBy: "https://pokeapi.co/api/v2/pokemon/").last ?? ""
        id = String(id.dropLast())
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(String(describing: id)).png"
    }
}

struct SemNome: Equatable {
    var pokemonList: Pokemon
    var nextUrl: String?
}
