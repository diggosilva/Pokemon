//
//  DetailsView.swift
//  Pokemon
//
//  Created by Diggo Silva on 28/04/24.
//

import UIKit
import SDWebImage

class DetailsView: UIView {
    lazy var viewCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.75
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var imagePokemon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemIndigo.withAlphaComponent(0.5)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemIndigo.cgColor
        return imageView
    }()
    
    lazy var labelHeight: UILabel = {
        buildLabelCard(text: "Altura: ")
    }()
    
    lazy var labelWeight: UILabel = {
        buildLabelCard(text: "Peso: ")
    }()
    
    lazy var labelXp: UILabel = {
        buildLabelCard(text: "XP: ", textAlignment: .left)
    }()
    
    lazy var labelId: UILabel = {
        buildLabelCard(text: "ID: ", textAlignment: .left)
    }()
    
    lazy var labelName: UILabel = {
        buildLabelCard(text: "NOME DO POKEMON", textAlignment: .center, numberOfLines: 0, fontSize: 22)
    }()
    
    private func buildLabelCard(text: String, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1, fontSize: CGFloat = 18) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .monospacedSystemFont(ofSize: fontSize, weight: .semibold)
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(pokemonDetails: PokemonDetails) {
        guard let url = URL(string: pokemonDetails.imageURL) else { return }
        imagePokemon.sd_setImage(with: url)
        labelHeight.text = "Altura: \(pokemonDetails.height)cm"
        labelWeight.text = "Peso: \(pokemonDetails.weight)g"
        labelXp.text = "XP: \(pokemonDetails.experience)"
        labelId.text = "ID: \(pokemonDetails.id)"
        labelName.text = "\(pokemonDetails.name)"
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        backgroundColor = .systemBackground
        addSubviews([viewCard, imagePokemon, labelHeight, labelWeight, labelXp, labelId, labelName])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            viewCard.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            viewCard.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewCard.widthAnchor.constraint(equalToConstant: 300),
            viewCard.heightAnchor.constraint(equalToConstant: 400),
            
            imagePokemon.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 20),
            imagePokemon.leadingAnchor.constraint(equalTo: viewCard.leadingAnchor, constant: 20),
            imagePokemon.trailingAnchor.constraint(equalTo: viewCard.trailingAnchor, constant: -20),
            imagePokemon.centerXAnchor.constraint(equalTo: viewCard.centerXAnchor),
            imagePokemon.heightAnchor.constraint(equalToConstant: 300),
            
            labelHeight.topAnchor.constraint(equalTo: imagePokemon.bottomAnchor, constant: 10),
            labelHeight.leadingAnchor.constraint(equalTo: imagePokemon.leadingAnchor),
            
            labelWeight.topAnchor.constraint(equalTo: labelHeight.bottomAnchor, constant: 10),
            labelWeight.leadingAnchor.constraint(equalTo: imagePokemon.leadingAnchor),
            
            labelXp.topAnchor.constraint(equalTo: imagePokemon.bottomAnchor, constant: 10),
            labelXp.trailingAnchor.constraint(equalTo: imagePokemon.trailingAnchor),
            
            labelId.topAnchor.constraint(equalTo: labelXp.bottomAnchor, constant: 10),
            labelId.trailingAnchor.constraint(equalTo: imagePokemon.trailingAnchor),
            
            labelName.topAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: 20),
            labelName.leadingAnchor.constraint(equalTo: imagePokemon.leadingAnchor),
            labelName.trailingAnchor.constraint(equalTo: imagePokemon.trailingAnchor),
        ])
    }
}
