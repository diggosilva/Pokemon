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
    private (set) var state: Bindable<DetailsViewControllerStates> = Bindable(value: .loading)
    private var service = Service()

    let id: Int

    init(id: Int) {
        self.id = id
    }

    func loadDataDetails() {
        service.getDetails(id: id) { pokemonDetails in
            self.state.value = .loaded(pokemonDetails)
        } onError: { error in
            self.state.value = .error
        }
    }
}
