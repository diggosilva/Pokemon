//
//  LoginView.swift
//  Pokemon
//
//  Created by Diggo Silva on 07/02/25.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginButtonTapped()
    func signupButtonTapped()
}

class LoginView: UIView {
    
    // MARK: - Properties
    lazy var logoImage = buildImageLogo()
    lazy var emailTextField = buildTextField(placeholder: "Email", keyboardType: .emailAddress)
    lazy var passwordTextField = buildTextField(placeholder: "Senha", isSecureTextEntry: true)
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
        delegate?.loginButtonTapped()
    }
    
    @objc func signupButtonTapped() {
        delegate?.signupButtonTapped()
    }
    
    // MARK: - Setup
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
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding),
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 35),
            
            signupButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding * 2),
            signupButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            signupButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            spinner.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
        ])
    }
}
