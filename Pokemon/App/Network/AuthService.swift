//
//  AuthService.swift
//  Pokemon
//
//  Created by Diggo Silva on 11/02/25.
//

import FirebaseAuth

protocol AuthServiceProtocol {
    func checkIfUserIsLoggedIn() -> UserModel?
    func signup(email: String, password: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func loginUser(email: String, password: String, completion: @escaping(Result<String, LoginError>) -> Void)
    func logoutUser()
}

class AuthService: AuthServiceProtocol {
    let firebaseAuth = Auth.auth()
    
    func checkIfUserIsLoggedIn() -> UserModel? {
        guard let user = firebaseAuth.currentUser else { return nil }
        return UserModel(email: user.email ?? "")
    }
    
    func signup(email: String, password: String, completion: @escaping (Result<String, SignupError>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion(.failure(.signupFailed))
                return
            }
            if let userEmail = authResult?.user.email {
                completion(.success(userEmail))
                return
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping(Result<String, LoginError>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion(.failure(.loginFailed))
                return
            }
            
            if let userEmail = authResult?.user.email {
                completion(.success(userEmail))
                return
            }
        }
    }
    
    func logoutUser() {
        do {
            try firebaseAuth.signOut()
        } catch {
            print("Erro ao tentar fazer logout: \(error.localizedDescription)")
        }
    }
}
