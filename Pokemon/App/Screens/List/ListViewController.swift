//
//  ListViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 17/04/24.
//

import UIKit
import FirebaseAuth

class ListViewController: UIViewController {
    
    lazy var listView = ListView()
    lazy var viewModel = ListViewModel()
    
    override func loadView() {
        super.loadView()
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
        handleStates()
        viewModel.loadDataPokemons()
    }
    
    private func setNavBar() {
        view.backgroundColor = .systemBackground
        let titleView = UIImageView(image: UIImage(named: "logo"))
        titleView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleView
        navigationItem.hidesBackButton = true
        let barButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButtonTapped))
        barButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func logoutButtonTapped() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Erro ao tentar deslogar: \(signOutError)")
        }
    }
    
    private func setDelegatesAndDataSources() {
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
        listView.delegate = self
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
            self.listView.tableView.isHidden = true
            self.listView.labelError.isHidden = false
        }
        alert.addAction(ok)
        alert.addAction(nok)
        present(alert, animated: true)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else { return UITableViewCell() }
        cell.configure(pokemon: viewModel.cellForRowAt(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listView.searchBar.resignFirstResponder()
        let selectedPokemon = viewModel.cellForRowAt(indexPath: indexPath)
        
        let detailVC = DetailsViewController(id: selectedPokemon.getId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.tableView(forRowAt: indexPath)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBar(textDidChange: searchText)
        listView.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ListViewController: ListViewDelegate {
    func goToDetails(indexPath: IndexPath) {
        let pokemonId = viewModel.cellForRowAt(indexPath: indexPath).getId
        let detailsVC = DetailsViewController(id: pokemonId)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
