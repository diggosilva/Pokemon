//
//  DetailsViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 28/04/24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let detailsView = DetailsView()
    
    override func loadView() {
        super.loadView()
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
