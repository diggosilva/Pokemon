//
//  ListViewModel.swift
//  Pokemon
//
//  Created by Diggo Silva on 17/04/24.
//

import Foundation

enum ViewControllerStates {
    case loading
    case loaded
    case error
}

class ListViewModel {
    var state: Bindable<ViewControllerStates> = Bindable(value: .loading)
    
    func loadData() {
  
        state.value = .loaded
    }
}
