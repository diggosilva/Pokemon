//
//  ViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 17/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    var labelTest = UILabel()
    var viewModel = ViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        handleStates()
        
        labelTest.translatesAutoresizingMaskIntoConstraints = false
        labelTest.text = "Testar aqui"
        
        view.addSubview(labelTest)
        
        NSLayoutConstraint.activate([
            labelTest.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTest.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        viewModel.state.value = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.loadData()
        }
    }
    
    func handleStates() {
        viewModel.state.bind { states in
            switch states {
            case .loading:
                self.showLoadingState()
            case .loaded:
                self.showLoadedState()
            case .error:
                self.showErrorState()
            }
        }
    }
    
    func showLoadingState() {
        labelTest.text = "Loading..."
    }
    
    func showLoadedState() {
        labelTest.text = "Sucesso!"
    }
    
    func showErrorState() {
        labelTest.text = "Erro"
    }
    
    private func setNavBar() {
        view.backgroundColor = .systemBackground
        title = "Pokemons"
    }
}
