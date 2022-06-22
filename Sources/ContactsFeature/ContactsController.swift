//
//  ContactsController.swift
//
//
//  Created by Roberto Casula on 15/06/22.
//

import UIKit
import ContactsClient
import AuthClient

public class ContactsController: UIViewController {

    private let authClient: AuthClientProtocol
    private let contactsClient: ContactsClient

    private lazy var _view: ContactsView = { .init() }()

    public override func loadView() {
        view = _view
    }

    public init(
        authClient: AuthClientProtocol,
        contactsClient: ContactsClient
    ) {
        self.authClient = authClient
        self.contactsClient = contactsClient
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Contacts"

        setupBarButtonItems()
    }

    private func setupBarButtonItems() {
        self.navigationItem.leftBarButtonItem = .init(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddContact(sender:))
        )

        self.navigationItem.rightBarButtonItem = .init(
            title: "Logout",
            style: .done,
            target: self,
            action: #selector(didTapLogout(sender:))
        )
    }
}

extension ContactsController {

    @IBAction func didTapAddContact(sender: Any) {

    }

    @IBAction func didTapLogout(sender: Any) {
        do {
            try authClient.logout()
        } catch let error {
            showError(error: error)
        }
    }
}

extension ContactsController {

    private func showError(error: Error) {
        let alertController = UIAlertController(
            title: "Error", message: error.localizedDescription, preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
