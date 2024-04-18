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
    
    func loadData() {
        dispatchGroup.enter()
        service.getPokemonName { pokemonNames in
            for pokemonName in pokemonNames {
                self.dispatchGroup.enter()
                self.service.getPokemonImage(name: pokemonName.name) { pokemonImages in
                    self.pokemons.append(Pokemon(
                        name: pokemonName.name,
                        height: pokemonImages.height,
                        weight: pokemonImages.weight,
                        experience: pokemonImages.baseExperience,
                        id: pokemonImages.id,
                        image: pokemonImages.sprites.other.officialArtwork.frontDefault))
                    self.state.value = .loaded
                    self.dispatchGroup.leave()
                } onError: { error in
                    print(error)
                }
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
