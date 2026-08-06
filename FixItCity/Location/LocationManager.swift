//
//  LocationManager.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-08-05.
//

import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject {
    
    var authorizationStatus: CLAuthorizationStatus
    var currentLocation: CLLocation?
    var currentAddress: String?
    var currentCity: String?
    var errorMessages: String?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override init() {
        authorizationStatus = .notDetermined
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func requestLocationPermission() {
        
    }
    
    func requestCurrentLocation() {
        
    }
    
    func reverseGeocode(location: CLLocation) {
        
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
    }
}
