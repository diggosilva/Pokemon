//
//  ListView.swift
//  Pokemon
//
//  Created by Diggo Silva on 18/04/24.
//

import UIKit

protocol ListViewDelegate: AnyObject {
    func goToDetails(indexPath: IndexPath)
}

class ListView: UIView {
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Buscar pokemon..."
        searchBar.showsBookmarkButton = true
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Logado com email: "
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    var email: String = ""{
        didSet {
            emailLabel.text = "Logado com email: \(email)"
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        tableView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return tableView
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.color = .systemIndigo
        return spinner
    }()
    
    lazy var labelError: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tente novamente mais tarde!"
        label.textAlignment = .center
        label.isHidden = true
        label.textColor = .gray
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    weak var delegate: ListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        addSubviews([searchBar, emailLabel, tableView, spinner, labelError])
    }
    
    private func setConstraints() {
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: padding / 2),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            labelError.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelError.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
