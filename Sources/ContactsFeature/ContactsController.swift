//
//  ContactsController.swift
//
//
//  Created by Roberto Casula on 15/06/22.
//

import AuthClient
import ContactsClient
import SharedExtensions
import SharedModels
import UIKit

public protocol ContactsControllerDelegate: AnyObject {
    func contactsController(_ controller: ContactsController, startConversationWith contacts: [Contact])
}

public class ContactsController: UIViewController {

    private let authClient: AuthClientProtocol
    private let contactsClient: ContactsClient

    private lazy var _view: ContactsView = { .init() }()

    private var contacts: [Contact] = []

    public weak var delegate: ContactsControllerDelegate?

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
        setupTableView()
        loadContacts()
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

    private func setupTableView() {
        _view.tableView.registerCell(type: ContactCell.self)
        _view.tableView.dataSource = self
    }

    private func loadContacts() {
        contactsClient.getContacts { [weak self] result in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts
                DispatchQueue.main.async { [weak self] in
                    self?._view.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.showError(error: error)
                }
            }
        }
    }
}

extension ContactsController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard let cell = tableView.dequeueCell(withType: ContactCell.self, for: indexPath),
            let contact = contacts[safe: indexPath.row]
        else { return .init() }
        cell.configure(with: contact)
        return cell
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
