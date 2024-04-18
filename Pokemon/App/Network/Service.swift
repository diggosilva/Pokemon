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
    
    func getPokemonName(onSuccess: @escaping([PokemonResponse]) -> Void, onError: @escaping(Error) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20") else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let response = response as? HTTPURLResponse {
                    print("DEBUG: Status Code FOR NAME.. \(response.statusCode)")
                }
                
                if let data = data {
                    do {
                        let responseBackEnd = try JSONDecoder().decode(PokemonNameBackEnd.self, from: data)
                        var pokemonResponse: [PokemonResponse] = []
                       
                        for namePokemon in responseBackEnd.results {
                            pokemonResponse.append(PokemonResponse(name: namePokemon.name))
                        }
                        
                        onSuccess(pokemonResponse)
                        print("DEBUG: Nome dos Pokemons: \(pokemonResponse)")
                    } catch {
                        onError(error)
                        print("Erro ao decodificar Nome do Pokemon \(error.localizedDescription)")
                    }
                }
            }
        })
        dataTask?.resume()
    }
    
    func getPokemonImage(name: String, onSuccess: @escaping(PokemonImageBackEnd) -> Void, onError: @escaping(Error) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)") else { return }
        let urlRequest = URLRequest(url: url)
        
        dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let response = response as? HTTPURLResponse {
                    return print("DEBUG: Status Code FOR IMAGE.. \(response.statusCode)")
                }
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(PokemonImageBackEnd.self, from: data)
                        onSuccess(response)
                        print("DEBUG: IMAGENS.. \(response.sprites.other.officialArtwork.frontDefault)")
                    } catch {
                        onError(error)
                        print("Erro ao decodificar Imagem do Pokemon \(error)")
                    }
                }
            }
        })
        dataTask?.resume()
    }
}
