//
//  Pokemon.swift
//  Pokemon
//
//  Created by Diggo Silva on 18/04/24.
//

import Foundation

// MARK: Pokemon
struct PokemonFeed: Equatable {
    let name: String
    let url: String
    let image: String
    
    var imageURL: String {
        var id = url.components(separatedBy: "https://pokeapi.co/api/v2/pokemon/").last ?? ""
        id = String(id.dropLast())
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(String(describing: id)).png"
    }
}
