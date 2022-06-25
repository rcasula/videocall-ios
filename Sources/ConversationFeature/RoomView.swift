//
//  File.swift
//
//
//  Created by Roberto Casula on 24/06/22.
//

import Foundation
import SharedExtensions
import UIKit

class RoomView: UIView {

    var spinner: UIActivityIndicatorView?

    @UsesAutoLayout
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = false
        return view
    }()

    @UsesAutoLayout
    var bottomOverlayContainer: UIView = {
        let view = UIView()
        return view
    }()

    @UsesAutoLayout
    var grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    @UsesAutoLayout
    var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 12
        return view
    }()

    @UsesAutoLayout
    var bottomHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.alignment = .top
        view.spacing = 20
        return view
    }()

    @UsesAutoLayout var hangupButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(
            UIImage(named: "end-call", in: Bundle.module, compatibleWith: nil), for: .normal)
        view.tintColor = .red
        return view
    }()

    @UsesAutoLayout var disableVideoButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(
            UIImage(named: "enableVideo", in: Bundle.module, compatibleWith: nil), for: .normal)
        view.tintColor = .white
        view.backgroundColor = .darkGray
        return view
    }()

    @UsesAutoLayout var muteButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(
            UIImage(named: "unmute", in: Bundle.module, compatibleWith: nil), for: .normal)
        view.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        view.backgroundColor = .darkGray
        view.tintColor = .white
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()

    @UsesAutoLayout
    var cameraPreview: CameraPreview = { .init() }()

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        cameraPreview.layer.masksToBounds = true
        cameraPreview.layer.cornerRadius = 12
        cameraPreview.layer.shadowOffset = .init(width: -15, height: 20)
        cameraPreview.layer.shadowRadius = 5
        cameraPreview.layer.shadowOpacity = 0.5
        cameraPreview.layer.shadowColor = UIColor.black.cgColor
        //        cameraPreview.previewLayer.cornerRadius = 12
        //        cameraPreview.previewLayer.clipsToBounds = true
        //        cameraPreview.previewLayer.addShadow()

        if #available(iOS 11.0, *) {
            bottomOverlayContainer.layer.cornerRadius = 12
            bottomOverlayContainer.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
            ]
            bottomOverlayContainer.layer.masksToBounds = false
            bottomOverlayContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            bottomOverlayContainer.layer.shadowOffset = CGSize(width: 0, height: -3)
            bottomOverlayContainer.layer.shadowOpacity = 0.5
            bottomOverlayContainer.layer.shadowRadius = 6
        } else {
            bottomOverlayContainer.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        }

        hangupButton.layer.cornerRadius = hangupButton.bounds.width / 2
        hangupButton.clipsToBounds = true
        disableVideoButton.layer.cornerRadius = disableVideoButton.bounds.width / 2
        disableVideoButton.clipsToBounds = true
        muteButton.layer.cornerRadius = muteButton.bounds.width / 2
        muteButton.clipsToBounds = true

        grabberView.layer.cornerRadius = grabberView.bounds.height / 2
        grabberView.clipsToBounds = true
    }

    private func setupViews() {
        backgroundColor = .white
        addSubview(collectionView)
        addSubview(bottomOverlayContainer)
        addSubview(cameraPreview)

        bottomOverlayContainer.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(grabberView)
        bottomStackView.addArrangedSubview(bottomHStackView)
        bottomHStackView.addArrangedSubview(muteButton)
        bottomHStackView.addArrangedSubview(disableVideoButton)
        bottomHStackView.addArrangedSubview(hangupButton)

        //        collectionView.backgroundColor = .blue
        //        cameraPreview.backgroundColor = .yellow

        if #available(iOS 13.0, *) {
            bottomOverlayContainer.backgroundColor = .systemBackground
        } else {
            bottomOverlayContainer.backgroundColor = .white
        }

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            //            bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
            bottomOverlayContainer.topAnchor.constraint(
                equalTo: collectionView.bottomAnchor, constant: 8),
        ])

        var safeAreaBottom: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeAreaBottom = safeAreaInsets.bottom
        }

        NSLayoutConstraint.activate([
            bottomOverlayContainer.heightAnchor.constraint(equalToConstant: 120 + safeAreaBottom),
            bottomOverlayContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: bottomOverlayContainer.trailingAnchor),
            bottomAnchor.constraint(equalTo: bottomOverlayContainer.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(
                equalTo: bottomOverlayContainer.topAnchor, constant: 6),
            bottomStackView.leadingAnchor.constraint(
                equalTo: bottomOverlayContainer.leadingAnchor, constant: 12),
            bottomOverlayContainer.trailingAnchor.constraint(
                equalTo: bottomStackView.trailingAnchor, constant: 12),
            bottomOverlayContainer.bottomAnchor.constraint(equalTo: bottomStackView.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            cameraPreview.heightAnchor.constraint(equalToConstant: 100),
            cameraPreview.widthAnchor.constraint(equalTo: cameraPreview.heightAnchor),
            trailingAnchor.constraint(equalTo: cameraPreview.trailingAnchor, constant: 16),
            bottomOverlayContainer.topAnchor.constraint(
                equalTo: cameraPreview.bottomAnchor, constant: 16),
        ])

        NSLayoutConstraint.activate([
            grabberView.widthAnchor.constraint(equalToConstant: 32),
            grabberView.heightAnchor.constraint(equalToConstant: 4.5),
        ])

        NSLayoutConstraint.activate([
            hangupButton.widthAnchor.constraint(equalToConstant: 50),
            hangupButton.heightAnchor.constraint(equalTo: hangupButton.widthAnchor),
            disableVideoButton.widthAnchor.constraint(equalToConstant: 50),
            disableVideoButton.heightAnchor.constraint(equalTo: disableVideoButton.widthAnchor),
            muteButton.widthAnchor.constraint(equalToConstant: 50),
            muteButton.heightAnchor.constraint(equalTo: muteButton.widthAnchor),
        ])
    }
}

extension UIView {
    func addShadow(radius: CGFloat = 3, offset: CGSize = CGSize(width: 1.0, height: 1.0)) {
        layer.shadowOffset = offset
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
}
