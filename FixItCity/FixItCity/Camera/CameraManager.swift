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
        
        //does 3 checks, checks if user permission is needed, checks device is available, and check if input can be created
        guard await isAuthorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else {
            return
        }
        
        captureSession.beginConfiguration()
        
        //run this when function ends
        defer {
            self.captureSession.commitConfiguration()
        }
        
        //video output
        let videoOutput = AVCaptureVideoDataOutput()
        self.videoOutput = videoOutput
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        let photoOutput = AVCapturePhotoOutput()
        self.photoOutput = photoOutput
        
        //make sure session supports device input, video output, and photo output
        guard captureSession.canAddInput(deviceInput) else {
            return
        }
        
        guard captureSession.canAddOutput(videoOutput) else {
            return
        }
        
        guard captureSession.canAddOutput(photoOutput) else {
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(photoOutput)
        
        
        if let connection = videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
    }
    
    private func startSession() async {
        
        guard await isAuthorized else {
            return
        }
        
        captureSession.startRunning()
        
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
            return
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
