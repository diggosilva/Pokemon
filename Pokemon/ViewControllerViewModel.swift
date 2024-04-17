//
//  ViewControllerViewModel.swift
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

class ViewControllerViewModel {
    var state: Bindable<ViewControllerStates> = Bindable(value: .loading)
    
    func loadData() {
  
        state.value = .loaded
    }
}
