//
//  ListViewModel.swift
//  Pokemon
//
//  Created by Diggo Silva on 17/04/24.
//

import Foundation
import UIKit

enum ListViewControllerStates {
    case loading
    case loaded
    case error
}

class ListViewModel {
    var state: Bindable<ListViewControllerStates> = Bindable(value: .loading)
    var service = Service()
    
    private var pokemons: [Pokemon] = []
    private var filteredPokemons: [Pokemon] = []
    var dispatchGroup = DispatchGroup()
    
    func loadDataPokemons() {
        dispatchGroup.enter()
        service.getPokemonName { pokemonNames, id in
            self.pokemons = pokemonNames
            self.filteredPokemons = self.pokemons
            self.state.value = .loaded
            self.dispatchGroup.leave()
        } onError: { error in
            self.state.value = .error
        }
        dispatchGroup.notify(queue: .main) {
        }
    }
    
    func numberOfRows() -> Int {
        return filteredPokemons.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Pokemon {
        return filteredPokemons[indexPath.row]
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPokemons = []
        
        if searchText.isEmpty {
            filteredPokemons = pokemons
        } else {
            for value in pokemons {
                if value.name.uppercased().contains(searchText.uppercased()) {
                    filteredPokemons.append(value)
                }
            }
        }
    }
}
