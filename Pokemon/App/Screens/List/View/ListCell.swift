//
//  ListCell.swift
//  Pokemon
//
//  Created by Diggo Silva on 18/04/24.
//

import UIKit
import SDWebImage

class ListCell: UITableViewCell {
    static let identifier = "ListCell"
    
    lazy var viewBG: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var imagePokemon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 42
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.systemIndigo.cgColor
        image.backgroundColor = .systemIndigo.withAlphaComponent(0.5)
        return image
    }()
    
    lazy var namePokemon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAlphaValue(alpha: CGFloat) {
        viewBG.alpha = alpha
        imagePokemon.alpha = alpha
        namePokemon.alpha = alpha
    }
    
    func configure(pokemon: PokemonFeed) {
        setAlphaValue(alpha: 0)
        UIView.animate(withDuration: 0.2) {
            guard let url = URL(string: pokemon.imageURL) else { return }
            self.imagePokemon.sd_setImage(with: url)
            self.namePokemon.text = pokemon.name.capitalized
            self.accessoryType = .disclosureIndicator
            self.setAlphaValue(alpha: 1)
        }
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        backgroundColor = .clear
        addSubview(viewBG)
        viewBG.addSubview(imagePokemon)
        viewBG.addSubview(namePokemon)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            viewBG.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            viewBG.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            viewBG.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            viewBG.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            imagePokemon.topAnchor.constraint(equalTo: viewBG.topAnchor, constant: 5),
            imagePokemon.leadingAnchor.constraint(equalTo: viewBG.leadingAnchor, constant: 5),
            imagePokemon.bottomAnchor.constraint(equalTo: viewBG.bottomAnchor, constant: -5),
            imagePokemon.widthAnchor.constraint(equalToConstant: 84),
            imagePokemon.heightAnchor.constraint(equalToConstant: 84),
            
            namePokemon.centerYAnchor.constraint(equalTo: imagePokemon.centerYAnchor),
            namePokemon.leadingAnchor.constraint(equalTo: imagePokemon.trailingAnchor, constant: 10),
            namePokemon.trailingAnchor.constraint(equalTo: viewBG.trailingAnchor, constant: -10),
        ])
    }
}
