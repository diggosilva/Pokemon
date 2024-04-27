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
    
    var nextUrl: String = ""
    
    private var pokemons: [Pokemon] = []
    private var filteredPokemons: [Pokemon] = []
    
    func loadDataPokemons() {
        service.getPokemon(url: "https://pokeapi.co/api/v2/pokemon?limit=500&offset=0") { nextUrl, pokemonNames in
            self.nextUrl = nextUrl ?? ""
            self.pokemons = pokemonNames
            self.filteredPokemons = self.pokemons
            self.state.value = .loaded
        } onError: { error in
            self.state.value = .error
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex && filteredPokemons == pokemons {
            
            service.getPokemon(url: self.nextUrl) { nextUrl, pokemonNames in
                if self.nextUrl == nextUrl ?? "" {
                    self.pokemons.append(contentsOf: pokemonNames)
                    self.filteredPokemons.append(contentsOf: pokemonNames)
                    self.state.value = .loaded
                }
            } onError: { error in
                self.state.value = .error
            }
        }
    }
}
