//
//  LoginService.swift
//  TMSHomework-Lesson33
//
//  Created by Наталья Мазур on 6.04.24.
//

import Foundation

class LoginService {
    
    private let authService: AuthService = SwiftyKeychainKitAuthService.shared
    
    static let shared = LoginService()
    
    func signIn(login: String, password: String) {
        let authKey = UUID().uuidString
        authService.set(login, for: KeychainKeys.username)
        authService.set(password, for: KeychainKeys.password)
        authService.set(authKey, for: KeychainKeys.authToken)
        
        UserDefaults.standard.set("mainVC", forKey: "rootViewController")
    }
    
    func signOut() {
        authService.clean()
        UserDefaults.standard.set("loginVC", forKey: "rootViewController")
    }
}
