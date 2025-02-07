//
//  SignupView.swift
//  Pokemon
//
//  Created by Diggo Silva on 07/02/25.
//

import UIKit

protocol SignupViewDelegate: AnyObject {
    func signupButtonTapped()
    func loginButtonTapped()
}

class SignupView: UIView {
    
    // MARK: - Properties
    lazy var logoImage = buildImageLogo()
    lazy var emailTextField = buildTextField(placeholder: "Email", keyboardType: .emailAddress)
    lazy var passwordTextField = buildTextField(placeholder: "Senha", isSecureTextEntry: true)
    lazy var confirmPasswordTextField = buildTextField(placeholder: "Confirmar senha", isSecureTextEntry: true)
    lazy var signupButton = buildButton(title: "Cadastrar", color: .link, selector: #selector(signupButtonTapped))
    lazy var loginButton = buildButtonWith2Texts(title1: "Já tem uma conta?  ", title2: "Logar!", selector: #selector(loginButtonTapped))
    lazy var spinner = buildSpinner()
    
    weak var delegate: SignupViewDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Actions
    @objc func signupButtonTapped() {
        delegate?.signupButtonTapped()
    }
    
    @objc func loginButtonTapped() {
        delegate?.loginButtonTapped()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubviews([logoImage, emailTextField, passwordTextField, confirmPasswordTextField, signupButton, loginButton, spinner])
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
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: padding),
            signupButton.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 35),
            
            loginButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding * 2),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            spinner.centerXAnchor.constraint(equalTo: signupButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: signupButton.centerYAnchor),
        ])
    }
}
