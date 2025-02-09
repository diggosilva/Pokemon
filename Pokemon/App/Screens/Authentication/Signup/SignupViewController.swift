//
//  SignupViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 08/02/25.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    // MARK: - Properties
    let signupView = SignupView()
    
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
                self.showAlertError(title: "Erro no logout", message: SignupError.logoutFailed.localizedDescription)
            }
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
        guard let email = signupView.emailTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro no email", message: SignupError.invalidEmail.localizedDescription)
            signupView.emailTextField.text = ""
            return
        }
        
        // Verificando se o email tem formato válido
        if !isValidEmail(email) {
            showAlertError(title: "Erro no email", message: SignupError.invalidEmail.localizedDescription)
            return
        }
        
        guard let password = signupView.passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro na senha", message: SignupError.invalidPassword.localizedDescription)
            return
        }
        
        if password.count < 6 {
            showAlertError(title: "Erro na senha", message: SignupError.invalidPassword.localizedDescription)
            return
        }
        
        guard let confirmPassword = signupView.confirmPasswordTextField.text, !confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty, confirmPassword == password else {
            showAlertError(title: "Erro na confirmação de senha", message: SignupError.passwordsMismatch.localizedDescription)
            signupView.confirmPasswordTextField.text = ""
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.showAlertError(title: "Erro no cadastro", message: SignupError.signupFailed.localizedDescription)
                return
            } else {
                self.showAlertSuccess(title: "Cadastro realizado com sucesso!", message: "Faça o login para continuar!")
            }
        }
    }
    
    func loginButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Função para validar formato de email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

enum SignupError: String, Error {
    case invalidEmail = "Digite um email válido! Ex: exemplo@dominio.com"
    case invalidPassword = "A senha deve ter pelo menos 6 caracteres."
    case passwordsMismatch = "As senhas não coincidem. Por favor, verifique."
    case signupFailed = "Falha ao tentar cadastrar o usuário. Tente novamente."
    case logoutFailed = "Erro ao fazer logout. Tente novamente."
    
    var localizedDescription: String {
        return self.rawValue
    }
}
