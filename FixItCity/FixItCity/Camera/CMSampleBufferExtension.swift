//
//  CMSampleBufferExtension.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-05-24.
//

import Foundation
import CoreImage
import AVFoundation

extension CMSampleBuffer {
    var cgImage: CGImage? {
        //a raw pixel grid of an image
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(self)
        
        guard let imagePixelBuffer = pixelBuffer else {
            return nil
        }
        
        return CIImage(cvPixelBuffer: imagePixelBuffer).cgImage
    }
}
