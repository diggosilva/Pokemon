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
    
//    private var pokemons: [Pokemon] = []
//    private var filteredPokemons: [Pokemon] = []
    var dispatchGroup = DispatchGroup()
    var offset = 0
    
    private var pokemons: [SemNome] = []
    private var filteredPokemons: [SemNome] = []
    
//    func loadDataPokemons() {
//        dispatchGroup.enter()
//        service.getPokemonName(offset: 0) { pokemonNames, id in
//            self.pokemons = pokemonNames
//            self.filteredPokemons = self.pokemons
//            self.state.value = .loaded
//            self.dispatchGroup.leave()
//        } onError: { error in
//            self.state.value = .error
//        }
//        dispatchGroup.notify(queue: .main) {
//        }
//    }
    
    func loadDataPokemons() {
        dispatchGroup.enter()
        service.getPokemonName(offset: 0) { nextUrl, pokemonNames, id  in
            if nextUrl == nil {
                print("ESSA É A ÚLTIMA PÁGINA!")
                return
            }
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
    
    func cellForRowAt(indexPath: IndexPath) -> SemNome {
        return filteredPokemons[indexPath.row]
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPokemons = []
        
        if searchText.isEmpty {
            filteredPokemons = pokemons
        } else {
            for value in pokemons {
                if value.pokemonList.name.uppercased().contains(searchText.uppercased()) {
                    filteredPokemons.append(value)
                }
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
//        if indexPath.row == lastRowIndex && filteredPokemons == pokemons {
//            offset += 20
//            service.getPokemonName(offset: offset) { pokemons, ids in
//                self.pokemons.append(contentsOf: pokemons)
//                self.filteredPokemons.append(contentsOf: pokemons)
//                self.state.value = .loaded
//            } onError: { error in
//                self.state.value = .error
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex && filteredPokemons == pokemons {
            offset += 500
            service.getPokemonName(offset: offset) { nextUrl, pokemons, ids  in
                if nextUrl == nil {
                    print("ESSA É A ÚLTIMA PÁGINA!")
                    return
                }
                self.pokemons.append(contentsOf: pokemons)
                self.filteredPokemons.append(contentsOf: pokemons)
                self.state.value = .loaded
            } onError: { error in
                self.state.value = .error
            }
        }
    }
}
