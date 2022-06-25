//
//  File.swift
//
//
//  Created by Roberto Casula on 22/06/22.
//

import SharedModels
import UIKit

class ContactCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.layer.cornerRadius = (imageView?.bounds.height ?? 0) / 2
        imageView?.clipsToBounds = true
    }

    func configure(with contact: Contact) {
        textLabel?.text = contact.name
        detailTextLabel?.text = contact.surname
        imageView?.contentMode = .scaleAspectFit
        imageView?.tintColor = .lightGray
        imageView?.image = .init(
            color: .lightGray,
            size: .init(width: 12, height: 12)
        )
        imageView?.load(url: contact.avatarUrl)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
