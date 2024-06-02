//
//  PokemonDetails.swift
//  Pokemon
//
//  Created by Diggo Silva on 27/04/24.
//

import Foundation

struct PokemonDetails {
    let name: String
    let url: String
    let id: Int
    let height: Int
    let weight: Int
    let experience: Int
    let image: String
    
    var imageURL: String {
        let id = url.components(separatedBy: "https://pokeapi.co/api/v2/pokemon/").last ?? ""
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(String(describing: id)).png"
    }
    
    var urlString: String {
        return "https://pokeapi.co/api/v2/pokemon/\(id)"
    }
}
