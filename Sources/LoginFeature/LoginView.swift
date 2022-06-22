//
//  LoginView.swift
//  
//
//  Created by Roberto Casula on 20/06/22.
//

import UIKit
import Foundation
import SharedExtensions

class LoginView: UIView {

    @UsesAutoLayout
    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 24
        return view
    }()

    @UsesAutoLayout
    private var fieldsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 16
        return view
    }()


    @UsesAutoLayout
    var usernameField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "Username"
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        return view
    }()

    @UsesAutoLayout
    var passwordField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.isSecureTextEntry = true
        view.placeholder = "Password"
        return view
    }()

    @UsesAutoLayout
    var loginButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Login", for: .normal)
        view.backgroundColor = .systemBlue
        view.tintColor = .white
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.contentEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white
        addSubview(stackView)

        fieldsStackView.addArrangedSubview(usernameField)
        fieldsStackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(fieldsStackView)
        stackView.addArrangedSubview(loginButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            fieldsStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            usernameField.widthAnchor.constraint(equalTo: fieldsStackView.widthAnchor),
            passwordField.widthAnchor.constraint(equalTo: fieldsStackView.widthAnchor)
        ])
    }
}
