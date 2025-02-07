//
//  SignupViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 07/02/25.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    let signupView = SignupView()
    
    override func loadView() {
        super.loadView()
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
    }
    
    private func setNavBar() {
        title = "Cadastro"
    }
    
    private func setDelegatesAndDataSources() {
        signupView.delegate = self
    }
    
    private func showAlertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { action in
            self.setupSignupButtonWhenTapped(setTitle: "Cadastrar", startAnimating: false)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func showAlertSuccess(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { action in
            do {
                try Auth.auth().signOut()
                // Voltar pra tela de Login
            } catch {
                self.showAlertError(title: "Erro ao fazer logout", message: error.localizedDescription)
            }
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func setupSignupButtonWhenTapped(setTitle: String = "", startAnimating: Bool = true) {
        if startAnimating {
            signupView.signupButton.setTitle(setTitle, for: .normal)
            signupView.spinner.startAnimating()
        } else {
            signupView.signupButton.setTitle(setTitle, for: .normal)
            signupView.spinner.stopAnimating()
        }
    }
}

extension SignupViewController: SignupViewDelegate {
    func signupButtonTapped() {
        setupSignupButtonWhenTapped()
        guard let email = signupView.emailTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro no email!", message: "Digite um email válido!")
            signupView.emailTextField.text = ""
            return
        }
        
        guard let password = signupView.passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro na senha!", message: "Digite uma senha válida!")
            signupView.passwordTextField.text = ""
            return
        }
        
        guard let confirmPassword = signupView.confirmPasswordTextField.text, !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty, confirmPassword == password else {
            showAlertError(title: "Erro na confirmação de senha!", message: "As senhas não coincidem!")
            signupView.confirmPasswordTextField.text = ""
            return
        }
        
        let firebaseAuth = Auth.auth()
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlertError(title: "Erro no cadastro!", message: "Erro ao cadastrar usuário: \(error.localizedDescription)")
            } else {
                self.showAlertSuccess(title: "Cadastro realizado!", message: "Usuário cadastrado com sucesso!")
            }
        }
    }
    
    func loginButtonTapped() {
        print("Voltar pra tela de Login")
    }
}
