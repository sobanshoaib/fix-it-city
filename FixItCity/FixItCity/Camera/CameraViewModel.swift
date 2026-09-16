//
//  CameraViewModel.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-05-24.
//

import Foundation
import CoreImage
import Observation
import UIKit

@Observable
class CameraViewModel {
    var currentFrame: CGImage?
    var capturedPhoto: CapturedPhoto?
    
    private let cameraManager = CameraManager()
    private let locationManager = LocationManager()
    private var isStreamingStarted = false
        
    func startCameraStream() {
        guard !isStreamingStarted else {
            return
        }
        isStreamingStarted = true
        locationManager.requestLocationPermission()
        
        Task {
            await handleCameraPreviews()
                    }
    }
    
    func handleCameraPreviews() async {
        for await image in cameraManager.previewStream {
            Task { @MainActor in
                self.currentFrame = image
            }
        }
    }
    
    func takePhoto() {
        cameraManager.takePhoto {image in
            DispatchQueue.main.async {
                self.locationManager.requestCurrentLocation {
                    photoLocation in
                    DispatchQueue.main.async {
                        self.capturedPhoto = CapturedPhoto(capturedPhoto: image, location: photoLocation)
                    }
                }
            }
        }
    }
    
}
