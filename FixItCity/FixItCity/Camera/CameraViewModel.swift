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
    var prediction: String = ""
    
    private let cameraManager = CameraManager()
    
    init() {
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
            for await image in cameraManager.previewStream {
                Task { @MainActor in
                    currentFrame = image
                }
                
            }
        }
}
