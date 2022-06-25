//
//  File.swift
//  
//
//  Created by Roberto Casula on 24/06/22.
//

import Foundation
import UIKit
import SharedModels
import AVFoundation

private enum SessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
}

public class RoomController: UIViewController {

    private lazy var _view: RoomView = { .init() }()
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var isSessionRunning = false
    private var setupResult: SessionSetupResult = .success
    private var isAudioEnabled: Bool = true

    private let contacts: [Contact]
    private var room: Room

    public init(contacts: [Contact]) {
        self.contacts = contacts
        self.room = .init(contacts: contacts)
        super.init(nibName: nil, bundle: nil)
        room.delegate = self

        _view.hangupButton.addTarget(self, action: #selector(didTapHangup(sender:)), for: .touchUpInside)
        _view.disableVideoButton.addTarget(self, action: #selector(didTapDisableVideo(sender:)), for: .touchUpInside)
        _view.muteButton.addTarget(self, action: #selector(didTapMuteMicrofone(sender:)), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = _view
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSession()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        room.connect()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        room.disconnect()
    }

    private func setupCollectionView() {
        _view.collectionView.registerCell(type: StreamCell.self)
        _view.collectionView.dataSource = self
        _view.collectionView.delegate = self
        _view.collectionView.contentInset = .init(top: 8, left: 8, bottom: 0, right: 8)
    }

    @IBAction func didTapHangup(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapDisableVideo(sender: Any) {
        if isSessionRunning {
            stopVideo()
            _view.cameraPreview.previewLayer.isHidden = true
            _view.disableVideoButton.tintColor = .lightGray
        } else {
            startVideo()
            _view.cameraPreview.previewLayer.isHidden = false
            _view.disableVideoButton.tintColor = .white
        }
    }

    @IBAction func didTapMuteMicrofone(sender: Any) {
        isAudioEnabled.toggle()
        if isAudioEnabled {
            _view.muteButton.setImage(UIImage(named: "unmute", in: Bundle.module, compatibleWith: nil), for: .normal)
        } else {
            _view.muteButton.setImage(UIImage(named: "mute", in: Bundle.module, compatibleWith: nil), for: .normal)
        }
    }

    private func setupSession() {
        _view.cameraPreview.session = captureSession
        _view.cameraPreview.previewLayer.videoGravity = .resizeAspectFill
        /*
         Check the video authorization status. Video access is required and audio
         access is optional. If the user denies audio access, AVCam won't
         record audio during movie recording.
         */
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera.
            break

        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant
             video access. Suspend the session queue to delay session
             setup until the access request has completed.

             Note that audio access will be implicitly requested when we
             create an AVCaptureDeviceInput for audio during session setup.
             */
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })

        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
        }

        /*
         Setup the capture session.
         In general, it's not safe to mutate an AVCaptureSession or any of its
         inputs, outputs, or connections from multiple threads at the same time.

         Don't perform these tasks on the main queue because
         AVCaptureSession.startRunning() is a blocking call, which can
         take a long time. Dispatch session setup to the sessionQueue, so
         that the main queue isn't blocked, which keeps the UI responsive.
         */
        sessionQueue.async {
            self.setupCaptureSession()
        }
        DispatchQueue.main.async { [weak self] in
            let spinner = UIActivityIndicatorView()
            self?._view.spinner = spinner
            self?._view.spinner?.color = UIColor.yellow
            self?._view.cameraPreview.addSubview(spinner)
        }
    }

    private func setupCaptureSession() {
        guard setupResult == .success else { return }
        captureSession.beginConfiguration()
        guard
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoDeviceInput)
        else {
            setupResult = .configurationFailed
            captureSession.commitConfiguration()
            return
        }
        captureSession.addInput(videoDeviceInput)
        captureSession.commitConfiguration()
    }

    private func stopVideo() {
        sessionQueue.async {
            if self.setupResult == .success {
                self.captureSession.stopRunning()
                self.isSessionRunning = self.captureSession.isRunning
            }
        }
    }

    private func startVideo() {
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                // Only setup observers and start the session if setup succeeded.

                self.captureSession.startRunning()
                self.isSessionRunning = self.captureSession.isRunning

            case .notAuthorized:
                DispatchQueue.main.async {
                    let changePrivacySetting = "AVCam doesn't have permission to use the camera, please change privacy settings"
                    let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))

                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                            style: .`default`,
                                                            handler: { _ in
                                                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                                                          options: [:],
                                                                                          completionHandler: nil)
                    }))

                    self.present(alertController, animated: true, completion: nil)
                }

            case .configurationFailed:
                DispatchQueue.main.async {
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension RoomController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return room.streams.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(withType: StreamCell.self, for: indexPath),
              let stream = room.streams[safe: indexPath.row]
        else { return .init() }
        cell.configure(with: stream)
        return cell
    }
}

extension RoomController: UICollectionViewDelegate {

    
}

extension RoomController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfRows = min(room.streams.count, 2)
        var numberOfItemsInRow: Int
        if room.streams.count <= 2 {
            numberOfItemsInRow = 1
        } else {
            numberOfItemsInRow = 2
        }
        let insets = collectionView.contentInset
        let safeAreaInsets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            safeAreaInsets = collectionView.safeAreaInsets
        } else {
            safeAreaInsets = UIApplication.shared.keyWindow?.layoutMargins ?? .zero
        }
        let size = CGSize(
            width: collectionView.bounds.width - insets.left - insets.right - safeAreaInsets.left - safeAreaInsets.right,
            height: collectionView.bounds.height - insets.top - insets.bottom - safeAreaInsets.top - safeAreaInsets.bottom
        )
        let width = (Int(size.width) - (numberOfItemsInRow - 1) * 4) / numberOfItemsInRow
        let height = (Int(size.height) - (numberOfRows - 1) * 4) / numberOfRows
        return CGSize(width: width, height: height)
    }
}

extension RoomController: RoomDelegate {
    func didConnect() {
        startVideo()
    }

    func didDisconnect() {
        stopVideo()
    }

    func room(_ room: Room, didAdd stream: Stream) {
        self._view.collectionView.reloadData()
    }

    func room(_ room: Room, didRemove stream: Stream) {
        self._view.collectionView.reloadData()
    }

}
