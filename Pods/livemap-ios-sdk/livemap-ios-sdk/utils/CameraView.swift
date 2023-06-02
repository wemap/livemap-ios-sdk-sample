//
//  CameraView.swift
//  livemap-ios-sdk
//
//  Created by Ilya Seliverstov on 02/05/2018.
//  Created by Bertrand Mathieu-Daudé on 20/10/2020.
//  Copyright © 2020 Bertrand Mathieu-Daudé. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CameraView: UIView {
    private lazy var captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                                               for: .video, position: .back)

    private lazy var videoDataOutputQueue: DispatchQueue = DispatchQueue(label: "JKVideoDataOutputQueue")
    private lazy var videoDataOutput: AVCaptureVideoDataOutput = {
        let videoData = AVCaptureVideoDataOutput()
        videoData.alwaysDiscardsLateVideoFrames = true
        videoData.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        videoData.connection(with: .video)?.isEnabled = true
        return videoData
    }()

    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        return preview
    }()

    private lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .hd1280x720
        return session
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentMode = .scaleAspectFit
    }

    override var isHidden: Bool {
        didSet {
            guard isHidden == false && !session.isRunning else { return }
            beginSession()
        }
    }
    
    public var onCameraAuthorizationRequest: ((_ granted: Bool) -> Void)? = nil
    public var onCameraAuthorizationStatusCheck: ((_ status: AVAuthorizationStatus) -> Void)? = nil

    private func beginSession() {
        do {
            guard let captureDevice = captureDevice else {
                fatalError("Camera doesn't work on the simulator! You have to test this on an actual device!")
            }
            
            let cameraMediaType = AVMediaType.video
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            
            if self.onCameraAuthorizationStatusCheck != nil {
                self.onCameraAuthorizationStatusCheck!(cameraAuthorizationStatus)
            }
            
            if cameraAuthorizationStatus == .notDetermined {
                // Prompting user for the permission to use the camera.
                AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                    if self.onCameraAuthorizationRequest != nil {
                        self.onCameraAuthorizationRequest!(granted)
                    }
                }
            }

            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }

            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)
            }

            layer.masksToBounds = true
            layer.addSublayer(previewLayer)
            previewLayer.frame = bounds

            session.startRunning()
        } catch let error {
            debugPrint("\(self.self): \(#function) line: \(#line).  \(error.localizedDescription)")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
}

extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate { /* nothing to do */ }
