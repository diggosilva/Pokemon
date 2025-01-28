//
//  MainScreenViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 26/01/25.
//

import UIKit

class MainScreenViewController: UIViewController {
    lazy var bg: UIView = {
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = .systemIndigo.withAlphaComponent(0.5)
        return bg
    }()
    
    lazy var logoImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "logo")
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        img.addGestureRecognizer(tapGesture)
        return img
    }()
    
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        startAnimationLogo()
    }
    
    @objc private func logoTapped() {
        timer?.invalidate()
        let listVC = ListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    private func startAnimationLogo() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.animateLogo(duration: 0.1, rotationAngle: 0.05)
        })
    }
    
    private func animateLogo(duration: CGFloat, rotationAngle: CGFloat) {
        UIView.animate(withDuration: duration, animations: {
            self.logoImage.transform = self.logoImage.transform.rotated(by: rotationAngle)
        }) { _ in
            UIView.animate(withDuration: duration, animations: {
                self.logoImage.transform = self.logoImage.transform.rotated(by: -rotationAngle * 2)
            }) { _ in
                UIView.animate(withDuration: duration, animations: {
                    self.logoImage.transform = self.logoImage.transform.rotated(by: rotationAngle)
                })
            }
        }
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        view.backgroundColor = .systemBackground
        view.addSubviews([bg, logoImage])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: view.topAnchor),
            bg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bg.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 200),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor),
        ])
    }
}
