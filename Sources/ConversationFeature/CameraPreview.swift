//
//  CameraPreview.swift
//  
//
//  Created by Roberto Casula on 25/06/22.
//

import AVFoundation
import UIKit

class CameraPreview: UIView {

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }

    // Connect the layer to a capture session.
    var session: AVCaptureSession? {
        get { previewLayer.session }
        set { previewLayer.session = newValue }
    }
}
