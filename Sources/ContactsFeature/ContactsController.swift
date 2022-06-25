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
    private var selectedContacts: Set<Contact> = []

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
        updateStartConversationButton()
    }

    private func setupBarButtonItems() {
        self.navigationItem.leftBarButtonItems = [
            .init(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(didTapAddContact(sender:))
            ),
            .init(
                barButtonSystemItem: .camera,
                target: self,
                action: #selector(didTapStartConversation(sender:))
            )
        ]

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
        _view.tableView.delegate = self
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

    private func updateStartConversationButton() {
        navigationItem.leftBarButtonItems?.last?.isEnabled = !selectedContacts.isEmpty
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
        if selectedContacts.contains(contact) {
            cell.accessoryType = .checkmark
        } else if selectedContacts.count < 4 {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension ContactsController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: false) }
        guard let contact = contacts[safe: indexPath.row],
              let cell = tableView.cellForRow(at: indexPath)
        else { return }

        if selectedContacts.contains(contact) {
            cell.accessoryType = .none
            selectedContacts.remove(contact)
        } else if selectedContacts.count < 4 {
            cell.accessoryType = .checkmark
            selectedContacts.insert(contact)
        }

        updateStartConversationButton()
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
              let contact = contacts[safe: indexPath.row]
        else { return }
        if selectedContacts.contains(contact) {
            selectedContacts.remove(contact)
        }
        contactsClient.remove(contact: contact)
        self.contacts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        loadContacts()
    }
}

extension ContactsController {

    @IBAction func didTapAddContact(sender: Any) {
        let controller = NewContactController()
        controller.delegate = self
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    @IBAction func didTapStartConversation(sender: Any) {
        guard !selectedContacts.isEmpty else { return }
        delegate?.contactsController(self, startConversationWith: Array(selectedContacts))
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

extension ContactsController: NewContactControllerDelegate {

    func newContactController(_ controller: NewContactController, didSave contact: Contact) {
        controller.dismiss(animated: true, completion: nil)
        contactsClient.add(contact: contact)
        contacts.append(contact)
        _view.tableView.insertRows(at: [.init(row: contacts.count - 1, section: 0)], with: .automatic)
        loadContacts()
    }
}
