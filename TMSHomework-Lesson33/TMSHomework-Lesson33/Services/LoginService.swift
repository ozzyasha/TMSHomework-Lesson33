//
//  LoginService.swift
//  TMSHomework-Lesson33
//
//  Created by Наталья Мазур on 6.04.24.
//

import Foundation
import UIKit

class LoginService {
    
    private let authService: AuthService = SwiftyKeychainKitAuthService.shared
    
    static let shared = LoginService()
    
    func signIn(login: String, password: String) {
        let authKey = UUID().uuidString
        let currentDate = Date()
        let timeOfSignIn = currentDate.formatted(date: .abbreviated, time: .standard)
        
        authService.set(login, for: KeychainKeys.username)
        authService.set(password, for: KeychainKeys.password)
        authService.set(authKey, for: KeychainKeys.authToken)
        authService.set(timeOfSignIn, for: KeychainKeys.currentDate)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                let mainVC = MainViewController()
                window.rootViewController = mainVC
                
                if let delegate = UIApplication.shared.delegate as? SceneDelegate {
                    delegate.window = window
                }
            }
        }
        
        UserDefaults.standard.set("mainVC", forKey: "rootViewController")
        
        NotificationService.shared.authorizeNotification()
        NotificationService.shared.requestDateNotification(currentDate: currentDate)
    }
    
    func getUsername() -> String {
        return authService.getValue(for: KeychainKeys.username) ?? "Error: username not found"
    }
    
    func signOut(){
        let loginVC = LoginViewController()
        loginVC.usernameTextField.text = LoginService.shared.getUsername()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = loginVC
                
                if let delegate = UIApplication.shared.delegate as? SceneDelegate {
                    delegate.window = window
                }
            }
        }
        
        UserDefaults.standard.set("loginVC", forKey: "rootViewController")
        authService.clean()
    }
}
