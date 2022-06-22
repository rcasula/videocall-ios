//
//  LoginController.swift
//  
//
//  Created by Roberto Casula on 20/06/22.
//

import UIKit
import AuthClient

public class LoginController: UIViewController {

    private lazy var _view: LoginView = { .init() }()

    private let authClient: AuthClientProtocol

    public init(
        authClient: AuthClientProtocol
    ) {
        self.authClient = authClient
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = _view
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        _view.loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        _view.usernameField.delegate = self
        _view.passwordField.delegate = self
        _view.usernameField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        _view.passwordField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        updateButtonState()
    }

    private func updateButtonState() {
        guard let username = _view.usernameField.text,
              let password = _view.passwordField.text
        else { return }
        _view.loginButton.isEnabled = !username.isEmpty && !password.isEmpty
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        login()
    }

    private func login() {
        guard let username = _view.usernameField.text,
              !username.isEmpty,
              let password = _view.passwordField.text,
              !password.isEmpty
        else { return }
        _view.loginButton.startLoading()
        authClient.login(
            username: username,
            password: password
        ) { [weak self] result in
            debugPrint(result)
            self?._view.loginButton.stopLoading()
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.showError(error: error)
            }
        }
    }

    private func showError(error: Error) {
        let alertController = UIAlertController(
            title: "Error", message: error.localizedDescription, preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}

extension LoginController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login()
        return true
    }

    @IBAction func textFieldDidChange(_ textField: UITextField) {
        updateButtonState()
    }
}
