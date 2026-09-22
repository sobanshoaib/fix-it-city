//
//  PhotoLocation.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-08-05.
//

import Foundation
import CoreLocation
import CoreGraphics


struct PhotoLocationModel {
    var location: CLLocationCoordinate2D
    var address: String?
    var city: String?
}

struct CapturedPhoto {
    var capturedPhoto: CGImage
    var location: PhotoLocationModel?
}
