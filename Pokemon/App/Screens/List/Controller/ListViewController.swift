//
//  ListViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 17/04/24.
//

import UIKit

class ListViewController: UIViewController {
    
    lazy var viewModel = ListViewModel()
    lazy var listView = ListView(viewModel: viewModel)
    
    override func loadView() {
        super.loadView()
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        handleStates()
        viewModel.loadDataPokemons()
    }
    
    private func setNavBar() {
        view.backgroundColor = .systemBackground
        let titleView = UIImageView(image: UIImage(named: "logo"))
        titleView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleView
    }
    
    private func handleStates() {
        viewModel.state.bind { states in
            switch states {
            case .loading:
                return self.showLoadingState()
            case .loaded:
                return self.showLoadedState()
            case .error:
                return self.showErrorState()
            }
        }
    }
    
    func showLoadingState() {
        listView.removeFromSuperview()
    }
    
    private func showLoadedState() {
        listView.spinner.stopAnimating()
        listView.tableView.reloadData()
    }
    
    private func showErrorState() {
        let alert = UIAlertController(title: "Opa, Ocorreu um erro!", message: "Tentar novamente?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Sim", style: .default) { action in
            self.viewModel.loadDataPokemons()
        }
        let nok = UIAlertAction(title: "Não", style: .cancel) { action in
            self.listView.spinner.stopAnimating()
            self.listView.labelError.isHidden = false
        }
        alert.addAction(ok)
        alert.addAction(nok)
        present(alert, animated: true)
    }
}
