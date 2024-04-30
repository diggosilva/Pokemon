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
                            pokemon.append(PokemonFeed(name: namePokemon.name, url: namePokemon.url))
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
    
    func getDetails(id: Int, onSuccess: @escaping(PokemonDetails) -> Void, onError: @escaping(Error) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    print("STATUS CODE: \(response)")
                }
                if let data = data {
                    do {
                        let pokemonDetailsResponse = try JSONDecoder().decode(PokemonDetailsResponse.self, from: data)
                        let pokemonDetails = PokemonDetails(
                            name: pokemonDetailsResponse.forms[0].name.capitalized,
                            url: "https://pokeapi.co/api/v2/pokemon/\(pokemonDetailsResponse.id)",
                            id: pokemonDetailsResponse.id,
                            height: pokemonDetailsResponse.height,
                            weight: pokemonDetailsResponse.weight,
                            experience: pokemonDetailsResponse.baseExperience,
                            image: pokemonDetailsResponse.sprites.other.officialArtwork.frontDefault
                        )
                        onSuccess(pokemonDetails)
                        print("POKEMON SELECIONADO: \(pokemonDetails)")
                    } catch {
                        onError(error)
                    }
                }
            }
        })
        dataTask?.resume()
    }
}
