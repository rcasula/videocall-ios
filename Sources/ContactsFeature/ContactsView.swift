//
//  ContactsView.swift
//
//
//  Created by Roberto Casula on 21/06/22.
//

import Foundation
import SharedExtensions
import UIKit

class ContactsView: UIView {

    @UsesAutoLayout
    public private(set) var tableView: UITableView = {
        .init(
            frame: CGRect.zero,
            style: .plain
        )
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
        addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
        ])
    }
}
