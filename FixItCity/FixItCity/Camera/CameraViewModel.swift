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
    var capturedPhoto: CGImage?
    
    private let cameraManager = CameraManager()
    private var isStreamingStarted = false
        
    func startCameraStream() {
        guard !isStreamingStarted else {
            return
        }
        isStreamingStarted = true
        
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
                self.capturedPhoto = image
            }
        }
    }
    
}
