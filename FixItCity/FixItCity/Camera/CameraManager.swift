//
//  CameraManager.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-05-23.
//


//talks to AVFoundation. manages the camera


import Foundation


import Foundation
import AVFoundation
import UIKit

class CameraManager: NSObject {
    private let captureSession = AVCaptureSession() //does real time campture. director/central hub of camera setupt. connects input to output
    private var deviceInput: AVCaptureDeviceInput? //session cannot connect directly to the device (avcapturedevice). avcapturedeviceinput acts like an adapter to connect capturesession and capturedevice.
    private var videoOutput: AVCaptureVideoDataOutput? //what you want to get as output, so in this code it will be a video frame
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video) //the hadware device. device/physical camera that provides streams of media
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    private var photoOutput: AVCapturePhotoOutput? //used for capturing photos
    
    
    //check if app is authorized to use the camera
    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            return isAuthorized
        }
    }
    
    private var addToPreviewStream: ((CGImage) -> Void)?
    
    private var photoCaptureCompletion: ((CGImage) -> Void)?

    private var hasLoggedFirstFrame = false
    
    lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    override init() {
        super.init()
        
        //configure and start are async functions, so need to include it in Task. these work in the background
        Task {
            await configureSession()
            await startSession()
        }
    }
    
    private func configureSession() async {
        print("[CameraManager] configureSession started")

        let authorized = await isAuthorized
        print("[CameraManager] isAuthorized = \(authorized)")
        print("[CameraManager] systemPreferredCamera = \(String(describing: systemPreferredCamera))")

        //does 3 checks, checks if user permission is needed, checks device is available, and check if input can be created
        guard authorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else {
            print("[CameraManager] configureSession bailed on the first guard (authorized/device/input)")
            return
        }

        captureSession.beginConfiguration()

        //run this when function ends
        defer {
            self.captureSession.commitConfiguration()
            print("[CameraManager] committed configuration")
        }

        //video output
        let videoOutput = AVCaptureVideoDataOutput()
        self.videoOutput = videoOutput
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)

        let photoOutput = AVCapturePhotoOutput()
        self.photoOutput = photoOutput

        //make sure session supports device input, video output, and photo output
        guard captureSession.canAddInput(deviceInput) else {
            print("[CameraManager] canAddInput returned false")
            return
        }

        guard captureSession.canAddOutput(videoOutput) else {
            print("[CameraManager] canAddOutput(videoOutput) returned false")
            return
        }

        guard captureSession.canAddOutput(photoOutput) else {
            print("[CameraManager] canAddOutput(photoOutput) returned false")
            return
        }

        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(photoOutput)
        print("[CameraManager] input/outputs added")

        if let connection = videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
    }

    private func startSession() async {
        let authorized = await isAuthorized
        print("[CameraManager] startSession isAuthorized = \(authorized)")
        guard authorized else {
            return
        }

        captureSession.startRunning()
        print("[CameraManager] captureSession.isRunning = \(captureSession.isRunning)")
    }
    
    func takePhoto(completion: @escaping (CGImage) -> Void) {
        
        guard let photoOutput else {
            return
        }
        
        photoCaptureCompletion = completion
        let settings = AVCapturePhotoSettings()
        
        // tells camera to capture one photo
        photoOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    //camera gives frame (output). recieveing one cmsamplebuffer per frame, which is a chunck of raw video data
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else {
            print("[CameraManager] sampleBuffer.cgImage was nil")
            return
        }
        if !hasLoggedFirstFrame {
            hasLoggedFirstFrame = true
            print("[CameraManager] first frame delivered, addToPreviewStream is \(addToPreviewStream == nil ? "nil" : "set")")
        }
        addToPreviewStream?(currentFrame)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        
        guard error == nil else {
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        guard let uiImage = UIImage(data: imageData) else {
            return
        }
        
        guard let cgImage = uiImage.cgImage else {
            return
        }
        
        photoCaptureCompletion?(cgImage)
    }
}
