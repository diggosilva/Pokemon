//
//  DetailsViewModel.swift
//  Pokemon
//
//  Created by Diggo Silva on 28/04/24.
//

import Foundation

enum DetailsViewControllerStates {
    case loading
    case loaded(PokemonDetails)
    case error
}

class DetailsViewModel {
    var state: Bindable<DetailsViewControllerStates> = Bindable(value: .loading)
    private var service = Service()

    var id: Int

    init(id: Int) {
        self.id = id
    }

    func loadDataDetails() {
        service.getDetails(url: "https://pokeapi.co/api/v2/pokemon/\(id)") { pokemonDetails in
            self.state.value = .loaded(pokemonDetails)
        } onError: { error in
            self.state.value = .error
        }
    }
}
