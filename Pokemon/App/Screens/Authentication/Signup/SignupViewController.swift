//
//  SignupViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 08/02/25.
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setNavBar() {
        title = "CADASTRO"
        navigationItem.hidesBackButton = true
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
                self.navigationController?.popToRootViewController(animated: true)
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
    func signupButton() {
        setupSignupButtonWhenTapped()
        guard let email = signupView.emailTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro no email", message: "Digite um email válido!")
            signupView.emailTextField.text = ""
            return
        }
        
        guard let password = signupView.passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro na senha", message: "Digite uma senha válida!")
            return
        }
        
        guard let confirmPassword = signupView.confirmPasswordTextField.text, !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty, confirmPassword == password else {
            showAlertError(title: "Erro na confirmação de senha", message: "As senhas não coincidem!")
            signupView.confirmPasswordTextField.text = ""
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlertError(title: "Erro no cadastro", message: "Erro ao cadastrar usuário: \(error.localizedDescription)")
                return
            } else {
                self.showAlertSuccess(title: "Cadastro realizado com sucesso!", message: "Faça o login para continuar!")
            }
        }
    }
    
    func loginButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}
