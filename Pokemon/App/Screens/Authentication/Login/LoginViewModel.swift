//
//  LoginViewModel.swift
//  Pokemon
//
//  Created by Diggo Silva on 11/02/25.
//

import Foundation

enum LoginError: String, Error {
    case invalidEmail = "Digite um email válido! Ex: exemplo@dominio.com"
    case invalidPassword = "A senha deve ter pelo menos 6 caracteres."
    case loginFailed = "Falha na autenticação. Por favor, verifique suas credenciais."
    
    var localizedDescription: String {
        return self.rawValue
    }
}

protocol LoginViewModelProtocol {
    func checkIfUserIsLoggedIn() -> UserModel?
    func validateEmail(_ email: String) -> Result<String, LoginError>
    func validatePassword(_ password: String) -> Result<String, LoginError>
    func loginUser(email: String, password: String, completion: @escaping (Result<String, LoginError>) -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func checkIfUserIsLoggedIn() -> UserModel? {
        return authService.checkIfUserIsLoggedIn()
    }
    
    func validateEmail(_ email: String) -> Result<String, LoginError> {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            return .failure(.invalidEmail)
        }
        return .success(email)
    }
    
    func validatePassword(_ password: String) -> Result<String, LoginError> {
        guard password.count >= 6 else {
            return .failure(.invalidPassword)
        }
        return .success(password)
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<String, LoginError>) -> Void) {
        authService.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let email):
                completion(.success(email))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Função para validar formato de email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
