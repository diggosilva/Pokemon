//
//  AuthService.swift
//  Pokemon
//
//  Created by Diggo Silva on 11/02/25.
//

import FirebaseAuth

protocol AuthServiceProtocol {
    func signup(email: String, password: String, completion: @escaping(Result<String, SignupError>) -> Void)
    func logoutUser()
}

class AuthService: AuthServiceProtocol {
    let firebaseAuth = Auth.auth()
    
    func signup(email: String, password: String, completion: @escaping (Result<String, SignupError>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(.signupFailed))
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
