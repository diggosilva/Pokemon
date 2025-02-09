//
//  LoginView.swift
//  Pokemon
//
//  Created by Diggo Silva on 09/02/25.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginButton()
    func signupButton()
}

class LoginView: UIView {
    
    // MARK: - Properties
    lazy var logoImage = buildLogoImage()
    lazy var emailTextField = buildTextfield(placeholder: "Email")
    lazy var passwordTextField = buildTextfield(placeholder: "Senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var loginButton = buildButton(title: "Logar", color: .link, selector: #selector(loginButtonTapped))
    lazy var signupButton = buildButtonWith2Texts(title1: "Não tem uma conta?  ", title2: "Cadastre-se!", selector: #selector(signupButtonTapped))
    lazy var spinner = buildSpinner()
    
    weak var delegate: LoginViewDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Actions
    @objc func loginButtonTapped() {
        delegate?.loginButton()
    }
    
    @objc func signupButtonTapped() {
        delegate?.signupButton()
    }
    
    // MARK: - UI Configuration
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubviews([logoImage, emailTextField, passwordTextField, signupButton, loginButton, spinner])
    }
    
    private func setConstraints() {
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logoImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 150),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: padding),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            loginButton.heightAnchor.constraint(equalToConstant: 35),
            
            signupButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            signupButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            signupButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            spinner.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
        ])
    }
}
