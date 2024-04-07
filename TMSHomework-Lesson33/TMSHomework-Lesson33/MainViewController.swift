//
//  MainViewController.swift
//  TMSHomework-Lesson33
//
//  Created by Наталья Мазур on 6.04.24.
//

import UIKit

class MainViewController: UIViewController {
    
    private let authService = SwiftyKeychainKitAuthService.shared
    private var usernameLabel = UILabel()
    private let signOutButton = UIButton()
    private let stackView = UIStackView()
    
    // MARK: - MainViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
        testKeychain()
    }
    
    // MARK: - Setup UI
    private func setupUsernameLabel() {
        let username = authService.getValue(for: KeychainKeys.username) ?? "Error: username not found"
        let text = "Hello, " + username + "!👋"
        usernameLabel.font = UIFont.systemFont(ofSize: 40)
        
        let attributedUsernameText = NSMutableAttributedString(string: text)
        let usernameRange = (text as NSString).range(of: username)
        attributedUsernameText.addAttribute(.font, value: UIFont.systemFont(ofSize: 40, weight: .bold), range: usernameRange)
        usernameLabel.attributedText = attributedUsernameText
        
        usernameLabel.textAlignment = .left
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
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
        setupSignOutButton()
        
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(signOutButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            usernameLabel.widthAnchor.constraint(equalToConstant: 250),
            usernameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            signOutButton.widthAnchor.constraint(equalToConstant: 250),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    private func testKeychain() {
        print(authService.getValue(for: KeychainKeys.username) ?? "Error: username not found")
        print(authService.getValue(for: KeychainKeys.password) ?? "Error: password not found")
        print(authService.getValue(for: KeychainKeys.authToken) ?? "Error: authToken not found")
    }
    
    @objc func signOutButtonTapped() {
        let loginVC = LoginViewController()
        view.window?.rootViewController = loginVC
        UserDefaults.standard.set("loginVC", forKey: "rootViewController")
    }
    
    
}
