//
//  File.swift
//
//
//  Created by Roberto Casula on 22/06/22.
//

import UIKit

public class LoadingButton: UIButton {

    private var originalButtonText: String?
    private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    public var activityIndicatorColor: UIColor = .lightGray {
        didSet {
            activityIndicator.color = activityIndicatorColor
        }
    }

    public override var tintColor: UIColor! {
        didSet {
            activityIndicatorColor = tintColor
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicator)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func startLoading() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.originalButtonText = self?.titleLabel?.text
            self?.setTitle("", for: .normal)
            self?.isEnabled = false
            self?.activityIndicator.startAnimating()
        }
    }

    public func stopLoading() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.setTitle(self?.originalButtonText, for: .normal)
            self?.isEnabled = true
            self?.activityIndicator.stopAnimating()
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

}
