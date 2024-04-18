//
//  ListViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 17/04/24.
//

import UIKit

class ListViewController: UIViewController {
    
    var listView = ListView()
    var viewModel = ListViewModel()
    
    override func loadView() {
        super.loadView()
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        handleStates()
        viewModel.loadData()
    }
    
    private func setNavBar() {
        view.backgroundColor = .systemBackground
        let titleView = UIImageView(image: UIImage(named: "logo"))
        titleView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleView
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
        
    }
    
    func showLoadedState() {
       
    }
    
    func showErrorState() {
        
    }
}
