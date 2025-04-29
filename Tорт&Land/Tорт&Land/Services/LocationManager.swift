//
//  LocationManager.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import CoreLocation

@Observable
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private(set) var userLocation: CLLocationCoordinate2D?
    private(set) var authorizationStatus: CLAuthorizationStatus?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationAccess() {
        manager.requestWhenInUseAuthorization()
    }

    func getCurrentLocation() {
        manager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Task { @MainActor in
            authorizationStatus = status
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        Task { @MainActor in
            userLocation = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка получения геолокации: \(error.localizedDescription)")
    }

}
