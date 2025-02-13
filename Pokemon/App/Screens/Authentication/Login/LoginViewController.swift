//
//  LoginViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 08/02/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    let loginView = LoginView()
    let viewModel = LoginViewModel()
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
        navigateToListVCIfLoggedIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupLoginButtonWhenTapped(setTitle: "Logar", startAnimating: false)
        clearTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Configuration
    private func setNavBar() {
        title = "LOGIN"
    }
    
    private func setDelegatesAndDataSources() {
        loginView.delegate = self
    }
    
    private func navigateToListVCIfLoggedIn() {
        if let user = viewModel.checkIfUserIsLoggedIn() {
            let listVC = ListViewController()
            listVC.listView.email = user.email
            navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    private func clearTextFields() {
        loginView.emailTextField.text = ""
        loginView.passwordTextField.text = ""
    }
    
    // MARK: - Alerts
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Ops, algo deu errado!", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { action in
            self.setupLoginButtonWhenTapped(setTitle: "Logar", startAnimating: false)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    // MARK: - UI Updates
    private func setupLoginButtonWhenTapped(setTitle: String = "", startAnimating: Bool = true) {
        if startAnimating {
            loginView.loginButton.setTitle(setTitle, for: .normal)
            loginView.spinner.startAnimating()
        } else {
            loginView.loginButton.setTitle(setTitle, for: .normal)
            loginView.spinner.stopAnimating()
        }
    }
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func loginButton() {
        setupLoginButtonWhenTapped()
        
        // Validar email
        guard let email = loginView.emailTextField.text else { return }
        switch viewModel.validateEmail(email) {
        case .failure(let error):
            return showAlertError(message: error.localizedDescription)
        case .success(let validEmail):
            
            // Validar Senha
            guard let password = loginView.passwordTextField.text else { return }
            switch viewModel.validatePassword(password) {
            case .failure(let error):
                return showAlertError(message: error.localizedDescription)
            case .success(let validPassword):
                
                // Autenticar usuário e enviar pra tela de Feed do App
                viewModel.loginUser(email: validEmail, password: validPassword) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let email):
                        let listVC = ListViewController()
                        listVC.listView.email = email
                        navigationController?.pushViewController(listVC, animated: true)
                        
                    case .failure(let error):
                        return showAlertError(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func signupButton() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}
