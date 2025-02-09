//
//  LoginViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 08/02/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    let loginView = LoginView()
    
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
        if let user = Auth.auth().currentUser {
            if let email = user.email {
                let listVC = ListViewController()
                listVC.listView.email = email
                navigationController?.pushViewController(listVC, animated: true)
            }
        }
    }
    
    private func clearTextFields() {
        loginView.emailTextField.text = ""
        loginView.passwordTextField.text = ""
    }
    
    // MARK: - Alerts
    private func showAlertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
        
        guard let email = loginView.emailTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro no email", message: LoginError.invalidEmail.localizedDescription)
            loginView.emailTextField.text = ""
            return
        }
        
        // Verificando se o email tem formato válido
        if !isValidEmail(email) {
            showAlertError(title: "Erro no email", message: LoginError.invalidEmail.localizedDescription)
            return
        }
        
        guard let password = loginView.passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro na senha", message: LoginError.invalidPassword.localizedDescription)
            return
        }
        
        // Verificando se a senha tem o tamanho mínimo
        if password.count < 6 {
            showAlertError(title: "Erro na senha", message: LoginError.invalidPassword.localizedDescription)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if error != nil {
                self.showAlertError(title: "Erro no Login", message: "\(LoginError.loginFailed.localizedDescription)")
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
    
    func signupButton() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    // Função para validar formato de email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

enum LoginError: String, Error {
    case invalidEmail = "Digite um email válido! Ex: exemplo@dominio.com"
    case invalidPassword = "A senha deve ter pelo menos 6 caracteres."
    case loginFailed = "Falha na autenticação. Por favor, verifique suas credenciais."
    
    var localizedDescription: String {
        return self.rawValue
    }
}
