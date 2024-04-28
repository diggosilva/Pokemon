//
//  DetailsViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 28/04/24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let detailsView = DetailsView()
    let viewModel: DetailsViewModel
    
    init(id: Int) {
        self.viewModel = DetailsViewModel(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        handleStates()
        viewModel.loadDataDetails()
    }
    
    private func setNavBar() {
        view.backgroundColor = .systemBackground
    }
    
    func handleStates() {
        viewModel.state.bind { states in
            switch states {
            case .loading:
                return self.showLoadingState()
            case .loaded(let pokemonDetails):
                return self.showLoadedState(pokemonDetails: pokemonDetails)
            case .error:
                return self.showErrorState()
            }
        }
    }
    
    func showLoadingState() {
        detailsView.removeFromSuperview()
    }
    
    func showLoadedState(pokemonDetails: PokemonDetails) {
        detailsView.configure(pokemonDetails: pokemonDetails)
    }
    
    func showErrorState() {
        let alert = UIAlertController(title: "Opa, Ocorreu um erro!", message: "Tentar novamente?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Sim", style: .default) { action in
            self.viewModel.loadDataDetails()
        }
        let nok = UIAlertAction(title: "Não", style: .cancel) { action in
            self.detailsView.removeFromSuperview()
        }
        alert.addAction(ok)
        alert.addAction(nok)
        present(alert, animated: true)
    }
}
