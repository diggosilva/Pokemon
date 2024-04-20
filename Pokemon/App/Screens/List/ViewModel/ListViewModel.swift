//
//  ListViewModel.swift
//  Pokemon
//
//  Created by Diggo Silva on 17/04/24.
//

import Foundation

enum ListViewControllerStates {
    case loading
    case loaded
    case error
}

class ListViewModel {
    var state: Bindable<ListViewControllerStates> = Bindable(value: .loading)
    var service = Service()
    
    var pokemons: [Pokemon] = []
    var dispatchGroup = DispatchGroup()
    
    func loadDataPokemons() {
        dispatchGroup.enter()
        service.getPokemonName { pokemonNames, id in
            for pokemonName in pokemonNames {
                self.pokemons.append(Pokemon(
                    name: pokemonName.name,
                    height: pokemonName.height ?? 0,
                    weight: pokemonName.weight ?? 0,
                    experience: pokemonName.experience ?? 0,
                    id: pokemonName.id ?? 0,
                    image: pokemonName.image))
            }
            self.state.value = .loaded
            self.dispatchGroup.leave()
        } onError: { error in
            self.state.value = .error
        }
        dispatchGroup.notify(queue: .main) {
        }
    }
    
    func numberOfRows() -> Int {
        return pokemons.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Pokemon {
        return pokemons[indexPath.row]
    }
}
