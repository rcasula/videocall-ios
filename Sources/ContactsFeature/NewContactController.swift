//
//  File.swift
//  
//
//  Created by Roberto Casula on 25/06/22.
//

import UIKit
import SharedModels

protocol NewContactControllerDelegate: AnyObject {
    func newContactController(_ controller: NewContactController, didSave contact: Contact)
}

class NewContactController: UIViewController {

    private lazy var _view: NewContactView = { .init() }()

    weak var delegate: NewContactControllerDelegate?

    public override func loadView() {
        view = _view
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add contact"

        _view.saveButton.addTarget(self, action: #selector(saveContact(sender:)), for: .touchUpInside)
    }

    @IBAction func saveContact(sender: Any) {
        guard let name = _view.nameField.text,
              !name.isEmpty,
              let surname = _view.surnameField.text,
              !surname.isEmpty,
              let avatar = _view.avatarField.text,
              !avatar.isEmpty,
              let url = URL(string: avatar)
        else { return }
        let contact = Contact(name: name, surname: surname, avatarUrl: url)
        delegate?.newContactController(self, didSave: contact)
    }
}
