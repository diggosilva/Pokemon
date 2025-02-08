//
//  SignupView.swift
//  Pokemon
//
//  Created by Diggo Silva on 08/02/25.
//

import UIKit

protocol SignupViewDelegate: AnyObject {
    func signupButton()
    func loginButton()
}

class SignupView: UIView {
    
    lazy var logoImage = buildLogoImage()
    lazy var emailTextField = buildTextfield(placeholder: "Email")
    lazy var passwordTextField = buildTextfield(placeholder: "Senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var confirmPasswordTextField = buildTextfield(placeholder: "Confirmar senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var signupButton = buildButton(title: "Cadastrar", color: .link, selector: #selector(signupButtonTapped))
    lazy var loginButton = buildButtonWith2Texts(title1: "Já tem uma conta?  ", title2: "Logar!", selector: #selector(loginButtonTapped))
    lazy var spinner = buildSpinner()
    
    weak var delegate: SignupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func signupButtonTapped() {
        delegate?.signupButton()
    }
    
    @objc func loginButtonTapped() {
        delegate?.loginButton()
    }
    
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
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: padding),
            signupButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            signupButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            signupButton.heightAnchor.constraint(equalToConstant: 35),
            
            loginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            spinner.centerXAnchor.constraint(equalTo: signupButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: signupButton.centerYAnchor),
        ])
    }
}
