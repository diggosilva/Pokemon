//
//  LoginViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 07/02/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setNavBar() {
        title = "LOGIN"
    }
    
    private func setDelegatesAndDataSources() {
        loginView.delegate = self
    }
    
    private func clearFields() {
        loginView.emailTextField.text = ""
        loginView.passwordTextField.text = ""
    }
    
    private func navigateToListVCIfLoggedIn() {
        if let user = Auth.auth().currentUser {
            if let email = user.email {
                let listVC = ListViewController()
                listVC.listView.email = email
                navigationController?.pushViewController(listVC, animated: true)
            }
        }
    }
    
    private func showAlertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { action in
            self.setupLoginButtonWhenTapped(setTitle: "Logar", startAnimating: false)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func setupLoginButtonWhenTapped(setTitle: String = "", startAnimating: Bool = true) {
        if startAnimating {
            loginView.loginButton.setTitle(setTitle, for: .normal)
            loginView.spinner.startAnimating()
        } else {
            loginView.loginButton.setTitle(setTitle, for: .normal)
            loginView.spinner.stopAnimating()
        }
    }
}

extension LoginViewController: LoginViewDelegate {
    func loginButtonTapped() {
        setupLoginButtonWhenTapped()
        guard let email = loginView.emailTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro no email!", message: "Digite um email válido!")
            loginView.emailTextField.text = ""
            return
        }
        
        guard let password = loginView.passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro na senha!", message: "Digite uma senha válida!")
            loginView.passwordTextField.text = ""
            return
        }
        
        let firebaseAuth = Auth.auth()
        firebaseAuth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlertError(title: "Erro no login!", message: "Erro ao efetuar login: \(error.localizedDescription)")
                return
            } else {
                if let email = Auth.auth().currentUser?.email {
                    let listVC = ListViewController()
                    listVC.listView.email = email
                    self.navigationController?.pushViewController(listVC, animated: true)
                }
            }
        }
    }
    
    func signupButtonTapped() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}
