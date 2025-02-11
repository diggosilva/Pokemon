//
//  SignupViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 08/02/25.
//

import UIKit

class SignupViewController: UIViewController {
    
    // MARK: - Properties
    let signupView = SignupView()
    let viewModel = SignupViewModel()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Configuration
    private func setNavBar() {
        title = "CADASTRO"
        navigationItem.hidesBackButton = true
    }
    
    private func setDelegatesAndDataSources() {
        signupView.delegate = self
    }
    
    // MARK: - Alerts
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Ops, acorreu um erro!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { action in
            self.setupSignupButtonWhenTapped(setTitle: "Cadastrar", startAnimating: false)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func showAlertSuccess() {
        let alert = UIAlertController(title: "Cadastro realizado com sucesso!", message: "Faça o login para continuar!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { action in
            self.viewModel.logoutUser()
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    // MARK: - UI Updates
    private func setupSignupButtonWhenTapped(setTitle: String = "", startAnimating: Bool = true) {
        if startAnimating {
            signupView.signupButton.setTitle(setTitle, for: .normal)
            signupView.spinner.startAnimating()
        } else {
            signupView.signupButton.setTitle(setTitle, for: .normal)
            signupView.spinner.stopAnimating()
        }
    }
}

// MARK: - SignupViewDelegate
extension SignupViewController: SignupViewDelegate {
    func signupButton() {
        setupSignupButtonWhenTapped()
        
        // Validar email
        guard let email = signupView.emailTextField.text else { return }
        switch viewModel.validateEmail(email) {
        case .failure(let error):
            return showAlertError(message: error.localizedDescription)
        case .success(let validEmail):
            
            // Validar senha
            guard let password = signupView.passwordTextField.text else { return }
            switch viewModel.validatePassword(password) {
            case .failure(let error):
                return showAlertError(message: error.localizedDescription)
            case .success(let validPassword):
                
                // Validar confirmaçao da senha
                guard let confirmPassword = signupView.confirmPasswordTextField.text else { return }
                switch viewModel.validateConfirmPassword(confirmPassword, password) {
                case .failure(let error):
                    return showAlertError(message: error.localizedDescription)
                case .success(let validConfirmPassword):
                    
                    // Registrar usuário, deslogar usuário e encaminhar para tela de Login
                    viewModel.registerUser(email: email, password: validConfirmPassword) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let success):
                            return showAlertSuccess()
                        case .failure(let error):
                            return showAlertError(message: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func loginButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}
