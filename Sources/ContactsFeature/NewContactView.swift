//
//  File.swift
//  
//
//  Created by Roberto Casula on 25/06/22.
//

import UIKit
import SharedExtensions

class NewContactView: UIView {

    @UsesAutoLayout
    public private(set) var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()

    @UsesAutoLayout
    public private(set) var nameField: UITextField = {
        let view = UITextField()
        view.placeholder = "Name"
        return view
    }()

    @UsesAutoLayout
    public private(set) var surnameField: UITextField = {
        let view = UITextField()
        view.placeholder = "Surname"
        return view
    }()

    @UsesAutoLayout
    public private(set) var avatarField: UITextField = {
        let view = UITextField()
        view.placeholder = "Avatar"
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        return view
    }()

    @UsesAutoLayout
    public private(set) var saveButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Save", for: .normal)
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
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(surnameField)
        stackView.addArrangedSubview(avatarField)
        stackView.addArrangedSubview(saveButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 8),
        ])
    }
}

