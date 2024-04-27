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
    
    var nextUrl: String?
    
    private var pokemons: [PokemonFeed] = []
    private var filteredPokemons: [PokemonFeed] = []
    
    func loadDataPokemons() {
        fetchRequest(url: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0")
    }
    
    func numberOfRows() -> Int {
        return filteredPokemons.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> PokemonFeed {
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
            
            guard let nextUrl else { return }
            fetchRequest(url: nextUrl)
        }
    }
    
    func fetchRequest(url: String) {
        service.getPokemon(url: url) { nextUrl, pokemonNames in
            self.nextUrl = nextUrl
            self.pokemons.append(contentsOf: pokemonNames)
            self.filteredPokemons.append(contentsOf: pokemonNames)
            self.state.value = .loaded
        } onError: { error in
            self.state.value = .error
        }
    }
}
