//
//  LoginService.swift
//  TMSHomework-Lesson33
//
//  Created by Наталья Мазур on 6.04.24.
//

import Foundation

class LoginService {
    
    static let shared = LoginService()
    
    func signIn() -> String {
        let authKey = UUID().uuidString
        return authKey
    }
}
