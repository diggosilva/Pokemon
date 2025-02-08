//
//  LoginViewController.swift
//  Pokemon
//
//  Created by Diggo Silva on 08/02/25.
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
        clearTextFields()
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
    
    private func showAlertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { action in
            self.setupLoginButtonWhenTapped(setTitle: "Logar", startAnimating: false)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
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

extension LoginViewController: LoginViewDelegate {
    func loginButton() {
        setupLoginButtonWhenTapped()
        guard let email = loginView.emailTextField.text, !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro no email", message: "Digite um email válido!")
            loginView.emailTextField.text = ""
            return
        }
        
        guard let password = loginView.passwordTextField.text, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlertError(title: "Erro na senha", message: "Digite uma senha válida!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authresult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlertError(title: "Erro no Login", message: "Erro ao realizar o login: \(error.localizedDescription)")
                return
            } else {
                if let email = Auth.auth().currentUser?.email {
                    let listVC = ListViewController()
                    listVC.listView.email = email
                    navigationController?.pushViewController(listVC, animated: true)
                }
            }
        }
    }
    
    func signupButton() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}

protocol LoginViewDelegate: AnyObject {
    func loginButton()
    func signupButton()
}

class LoginView: UIView {
    
    lazy var logoImage = buildLogoImage()
    lazy var emailTextField = buildTextfield(placeholder: "Email")
    lazy var passwordTextField = buildTextfield(placeholder: "Senha", keyboardType: .default, isSecureTextEntry: true)
    lazy var loginButton = buildButton(title: "Logar", color: .link, selector: #selector(loginButtonTapped))
    lazy var signupButton = buildButtonWith2Texts(title1: "Não tem uma conta?  ", title2: "Cadastre-se!", selector: #selector(signupButtonTapped))
    lazy var spinner = buildSpinner()
    
    weak var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func loginButtonTapped() {
        delegate?.loginButton()
    }
    
    @objc func signupButtonTapped() {
        delegate?.signupButton()
    }
    
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
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            loginButton.heightAnchor.constraint(equalToConstant: 35),
            
            signupButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            signupButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            signupButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            spinner.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
        ])
    }
}
