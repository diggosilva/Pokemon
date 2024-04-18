//
//  ListCell.swift
//  Pokemon
//
//  Created by Diggo Silva on 18/04/24.
//

import UIKit

class ListCell: UITableViewCell {
    static let identifier = "ListCell"
    
    lazy var imagePokemon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person.circle")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        return image
    }()
    
    lazy var namePokemon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NOME DO POKEMON"
        label.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        addSubview(imagePokemon)
        addSubview(namePokemon)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imagePokemon.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imagePokemon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imagePokemon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            imagePokemon.widthAnchor.constraint(equalToConstant: 60),
            imagePokemon.heightAnchor.constraint(equalToConstant: 60),
            
            namePokemon.centerYAnchor.constraint(equalTo: imagePokemon.centerYAnchor),
            namePokemon.leadingAnchor.constraint(equalTo: imagePokemon.trailingAnchor, constant: 10),
            namePokemon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}
