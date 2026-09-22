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
    
    private var locationCompletion: ((PhotoLocationModel?) -> Void)?

    override init() {
        authorizationStatus = .notDetermined

        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func requestCurrentLocation(completion: ((PhotoLocationModel?) -> Void)? = nil) {
        locationCompletion = completion
        locationManager.requestLocation()
    }

    func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self else { return }
            
            if let error {
                self.errorMessages = error.localizedDescription
                self.locationCompletion?(PhotoLocationModel(location: location.coordinate, address: nil))
                self.locationCompletion = nil
                return
            }
            
            guard let placemark = placemarks?.first else {
                self.locationCompletion?(PhotoLocationModel(location: location.coordinate, address: nil))
                self.locationCompletion = nil
                return
            }
            
            self.currentCity = placemark.locality
            self.currentAddress = [
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.postalCode
            ]
                .compactMap{ $0 }
                .joined(separator: " ")
            self.locationCompletion?(PhotoLocationModel(location: location.coordinate, address: self.currentAddress, city: self.currentCity))
            self.locationCompletion = nil
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus

        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            return requestCurrentLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        currentLocation = location
        reverseGeocode(location: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessages = error.localizedDescription
        locationCompletion?(nil)
        locationCompletion = nil
    }
}
