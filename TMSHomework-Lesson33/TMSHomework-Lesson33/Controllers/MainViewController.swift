//
//  MainViewController.swift
//  TMSHomework-Lesson33
//
//  Created by Наталья Мазур on 6.04.24.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    private let authService = SwiftyKeychainKitAuthService.shared
    private let usernameLabel = UILabel()
    private let passwordLabel = UILabel()
    private let tokenLabel = UILabel()
    private let signOutTimerLabel = UILabel()
    private let timeOfSignInLabel = UILabel()
    private let signOutButton = UIButton()
    private let stackView = UIStackView()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - MainViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
    }
    
    // MARK: - Setup UI
    private func setupUsernameLabel() {
        let username = authService.getValue(for: KeychainKeys.username) ?? "Error: username not found"
        let text = String(localized: "Hello, \(username)!👋")
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
        passwordLabel.text = String(localized: "Password: \(password)")
        passwordLabel.textColor = .black
        passwordLabel.numberOfLines = 2
        passwordLabel.font = UIFont.systemFont(ofSize: 15)
        passwordLabel.textAlignment = .left
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTokenLabel() {
        let token = authService.getValue(for: KeychainKeys.authToken) ?? "Error: authToken not found"
        tokenLabel.text = String(localized: "Token: \(token)")
        tokenLabel.textColor = .black
        tokenLabel.numberOfLines = 3
        tokenLabel.font = UIFont.systemFont(ofSize: 15)
        tokenLabel.textAlignment = .left
        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTimeOfSignInLabel() {
        let date = authService.getValue(for: KeychainKeys.currentDate) ?? "Error: date not found"
        timeOfSignInLabel.text = String(localized: "Last time of sign in:\n \(date)")
        timeOfSignInLabel.textColor = .black
        timeOfSignInLabel.numberOfLines = 2
        timeOfSignInLabel.font = UIFont.systemFont(ofSize: 15)
        timeOfSignInLabel.textAlignment = .left
        timeOfSignInLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSignOutTimerLabel() {
        let countdownSeconds = 30
        
        Observable<Int>
            .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .map { value in
                return countdownSeconds - value
            }
            .take(30)
            .map { seconds in
                return String(localized: "The session will be cancelled in: \(String(format: "%02d:%02d", seconds / 60, seconds % 60))")
            }
            .bind(to: signOutTimerLabel.rx.text)
            .disposed(by: disposeBag)

        signOutTimerLabel.textColor = .black
        signOutTimerLabel.numberOfLines = 2
        signOutTimerLabel.font = UIFont.systemFont(ofSize: 15)
        signOutTimerLabel.textAlignment = .left
        signOutTimerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSignOutButton() {
        let signOutLocalizedString = String(localized: "Sign out")
        signOutButton.setTitle(signOutLocalizedString, for: .normal)
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
        setupSignOutTimerLabel()
        setupTimeOfSignInLabel()
        setupSignOutButton()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(passwordLabel)
        stackView.addArrangedSubview(tokenLabel)
        stackView.addArrangedSubview(signOutTimerLabel)
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
            
            signOutTimerLabel.widthAnchor.constraint(equalToConstant: 300),
            signOutTimerLabel.heightAnchor.constraint(equalToConstant: 50),
            
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
