//
//  MainViewController.swift
//  TMSHomework-Lesson33
//
//  Created by Наталья Мазур on 6.04.24.
//

import UIKit

class MainViewController: UIViewController {
    
    private let authService = SwiftyKeychainKitAuthService.shared
    private let usernameLabel = UILabel()
    private let passwordLabel = UILabel()
    private let tokenLabel = UILabel()
    private let timeOfSignInLabel = UILabel()
    private let signOutButton = UIButton()
    private let stackView = UIStackView()
    
    // MARK: - MainViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
    }
    
    // MARK: - Setup UI
    private func setupUsernameLabel() {
        let username = authService.getValue(for: KeychainKeys.username) ?? "Error: username not found"
        let text = "Hello, " + username + "!👋"
        usernameLabel.textColor = .black
        usernameLabel.font = UIFont.systemFont(ofSize: 25)
        
        let attributedUsernameText = NSMutableAttributedString(string: text)
        let usernameRange = (text as NSString).range(of: username)
        attributedUsernameText.addAttribute(.font, value: UIFont.systemFont(ofSize: 25, weight: .bold), range: usernameRange)
        usernameLabel.attributedText = attributedUsernameText
        
        usernameLabel.textAlignment = .left
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPasswordLabel() {
        let password = authService.getValue(for: KeychainKeys.password) ?? "Error: password not found"
        passwordLabel.text = "Password: " + password
        passwordLabel.textColor = .black
        passwordLabel.numberOfLines = 2
        passwordLabel.font = UIFont.systemFont(ofSize: 15)
        passwordLabel.textAlignment = .left
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTokenLabel() {
        let token = authService.getValue(for: KeychainKeys.authToken) ?? "Error: authToken not found"
        tokenLabel.text = "Token: " + token
        tokenLabel.textColor = .black
        tokenLabel.numberOfLines = 2
        tokenLabel.font = UIFont.systemFont(ofSize: 15)
        tokenLabel.textAlignment = .left
        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTimeOfSignInLabel() {
        let date = authService.getValue(for: KeychainKeys.currentDate) ?? "Error: date not found"
        timeOfSignInLabel.text = "Last time of sign in:\n" + date
        timeOfSignInLabel.textColor = .black
        timeOfSignInLabel.numberOfLines = 2
        timeOfSignInLabel.font = UIFont.systemFont(ofSize: 15)
        timeOfSignInLabel.textAlignment = .left
        timeOfSignInLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSignOutButton() {
        signOutButton.setTitle("Sign out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.layer.cornerRadius = 5
        signOutButton.backgroundColor = .systemBlue
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStackView() {
        setupUsernameLabel()
        setupPasswordLabel()
        setupTokenLabel()
        setupTimeOfSignInLabel()
        setupSignOutButton()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(passwordLabel)
        stackView.addArrangedSubview(tokenLabel)
        stackView.addArrangedSubview(timeOfSignInLabel)
        stackView.setCustomSpacing(50, after: timeOfSignInLabel)
        stackView.addArrangedSubview(signOutButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            usernameLabel.widthAnchor.constraint(equalToConstant: 300),
            usernameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLabel.widthAnchor.constraint(equalToConstant: 300),
            passwordLabel.heightAnchor.constraint(equalToConstant: 50),
            
            tokenLabel.widthAnchor.constraint(equalToConstant: 300),
            tokenLabel.heightAnchor.constraint(equalToConstant: 50),
            
            timeOfSignInLabel.widthAnchor.constraint(equalToConstant: 300),
            timeOfSignInLabel.heightAnchor.constraint(equalToConstant: 50),
            
            signOutButton.widthAnchor.constraint(equalToConstant: 250),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    // MARK: - @objc func
    @objc func signOutButtonTapped() {
        LoginService.shared.signOut()
    }
    
    
}
