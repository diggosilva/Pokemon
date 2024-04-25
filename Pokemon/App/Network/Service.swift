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
    
    func getPokemonName(offset: Int, onSuccess: @escaping([Pokemon], [String]) -> Void, onError: @escaping(Error) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=\(offset)") else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let response = response as? HTTPURLResponse {
                    print("DEBUG: Status Code.. \(response.statusCode)")
                }
                if let data = data {
                    do {
                        let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
                        var pokemon: [Pokemon] = []
                        var ids: [String] = []
                        
                        for namePokemon in pokemonResponse.results {
                            var id = namePokemon.url.components(separatedBy: "https://pokeapi.co/api/v2/pokemon/").last ?? ""
                            id = String(id.dropLast())
                            ids.append(id)
                            let urlImage = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
                            
                            pokemon.append(Pokemon(name: namePokemon.name, url: namePokemon.url, id: nil, height: nil, weight: nil, experience: nil, image: urlImage))
                        }
                        onSuccess(pokemon, ids)
                        print("DEBUG: Nome dos Pokemons: \(pokemon)")
                        print("DEBUG: ID dos Pokemons: \(ids)")
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
