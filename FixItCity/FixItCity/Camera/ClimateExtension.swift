//
//  ClimateExtension.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-05-24.
//

import Foundation
import CoreImage

extension CIImage {
    
    var cgImage: CGImage? {
        let ciContext = CIContext()
        
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else {
            return nil
        }
        
        return cgImage
    }
    
}
