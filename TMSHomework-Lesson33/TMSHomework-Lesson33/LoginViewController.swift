//
//  LoginViewController.swift
//  TMSHomework-Lesson33
//
//  Created by Наталья Мазур on 4.04.24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let signInLabel = UILabel()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let stackView = UIStackView()
    private let signInButton = UIButton()
    
    private var stackViewCenterYConstraint = NSLayoutConstraint()
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addKeyboardObserver()
        setupStackView()
    }
    
    // MARK: - Setup UI
    private func setupSignInLabel() {
        signInLabel.text = "Sign in"
        signInLabel.textAlignment = .center
        signInLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUsernameTextField() {
        usernameTextField.delegate = self
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.placeholder = "username"
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPasswordTextField() {
        passwordTextField.delegate = self
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "password"
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSignInButton() {
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.layer.cornerRadius = 5
        signInButton.backgroundColor = .systemGray
        signInButton.isEnabled = false
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupStackView() {
        setupSignInLabel()
        setupUsernameTextField()
        setupPasswordTextField()
        setupSignInButton()
        
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(signInLabel)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
       
        stackViewCenterYConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        NSLayoutConstraint.activate([
            signInLabel.widthAnchor.constraint(equalToConstant: 250),
            signInLabel.heightAnchor.constraint(equalToConstant: 50),
            
            usernameTextField.widthAnchor.constraint(equalToConstant: 250),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.widthAnchor.constraint(equalToConstant: 250),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewCenterYConstraint
        ])
        
    }
    
    // MARK: - @objc func
    @objc func textFieldDidChange() {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            signInButton.backgroundColor = .systemGray
            signInButton.isEnabled = false
        } else {
            signInButton.backgroundColor = .systemBlue
            signInButton.isEnabled = true
        }
    }
    
    @objc func signInButtonTapped() {
        if let usernameText = usernameTextField.text, let passwordText = passwordTextField.text {
            LoginService.shared.signIn(login: usernameText, password: passwordText)
            let mainVC = MainViewController()
            view.window?.rootViewController = mainVC
        }
    }
    
    // MARK: - Keyboard Observing
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardAppeared(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let halfOfKeyboardHeight = keyboardHeight/2
            
            stackViewCenterYConstraint.isActive = false
            stackViewCenterYConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -halfOfKeyboardHeight)
            stackViewCenterYConstraint.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardDisappeared(_ notification: Notification) {
        stackViewCenterYConstraint.isActive = false
        stackViewCenterYConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        stackViewCenterYConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - LoginViewController Extensions
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//Сделать приложение, которое будет иметь экран локального входа, после входа должен сохраниться логин, пароль и полученный из сервиса ключ.
//Если вход осуществлен, при запуске открывать основной экран, а не экран с логином.
//Через сутки показать уведомление о требуемом релогине.
//
//*Если вход был больше суток назад, открывать экран логина с предзаполненным логином.
