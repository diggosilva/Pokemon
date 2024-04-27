//
//  Service.swift
//  Pokemon
//
//  Created by Diggo Silva on 18/04/24.
//

import Foundation

protocol ServiceProtocol {
    var dataTask: URLSessionDataTask? { get set }
    func isUpdating() -> Bool
}

class Service: ServiceProtocol {
    var dataTask: URLSessionDataTask?
    
    func isUpdating() -> Bool {
        if let dataTask = dataTask {
            return dataTask.state == .running
        }
        return false
    }
    
    func getPokemon(url: String, onSuccess: @escaping(String?, [PokemonFeed]) -> Void, onError: @escaping(Error) -> Void) {
        guard let url = URL(string: url) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    print("DEBUG: Status Code.. \(response.statusCode)")
                }
                if let data = data {
                    do {
                        let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
                        var pokemon: [PokemonFeed] = []
                        let nextUrl = pokemonResponse.next
                        
                        for namePokemon in pokemonResponse.results {
                            var id = namePokemon.url.components(separatedBy: "https://pokeapi.co/api/v2/pokemon/").last ?? ""
                            id = String(id.dropLast())
                            let urlImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
                            
                            pokemon.append(PokemonFeed(name: namePokemon.name, url: namePokemon.url, image: urlImage))
                        }
                        onSuccess(nextUrl, pokemon)
                        print("DEBUG: Nome dos Pokemons: \(pokemon)")
                    } catch {
                        onError(error)
                        print("Erro ao decodificar Nome do Pokemon \(error.localizedDescription)")
                    }
                }
            }
        })
        dataTask?.resume()
    }
}
