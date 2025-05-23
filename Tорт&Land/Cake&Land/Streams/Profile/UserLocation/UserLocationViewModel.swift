//
//  UserLocationViewModel.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import Observation
import Combine
import _MapKit_SwiftUI

@Observable
final class UserLocationViewModel: UserLocationDisplayLogic, UserLocationViewModelInput, UserLocationViewModelOutput {
    var uiProperties = UserLocationModel.UIProperties()
    var camera: MapCameraPosition = .region(.bmstuRegion)
    var mapSelection: MKMapItem?
    var action: (MKPlacemark) async throws -> Void
    private(set) var mapItems: [MKMapItem] = []
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(action: @escaping (MKPlacemark) async throws -> Void) {
        self.action = action
    }
}

// MARK: - Network

extension UserLocationViewModel {

    func fetchMapItems(inputText: String) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = inputText
        let results = try await MKLocalSearch(request: request).start()
        return results.mapItems
    }

}

extension UserLocationViewModel {

    func didInputText(_ oldText: String, _ newText: String) {
        guard !newText.isEmpty else { return }
        
        Task { @MainActor in
            let items = try await fetchMapItems(inputText: newText)
            mapItems = items
            uiProperties.showSheet = !items.isEmpty
        }
    }

    func didSelectAddress() {
        guard let selectedMapItem = mapSelection else {
            return
        }
        uiProperties.showButtonLoader = true
        Task { @MainActor in
            try await action(selectedMapItem.placemark)
            uiProperties.showButtonLoader = false
            uiProperties.showDetailsSheet = false
            coordinator?.openPreviousScreen()
        }
    }

    func didTapBackButton() {
        coordinator?.openPreviousScreen()
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func updateUserLocation(with coordinate: CLLocationCoordinate2D) async {
        // Центрируем камеру
        camera = .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))

        // Геокодинг
        let geocoder = CLGeocoder()

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(
                CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            )

            guard let placemark = placemarks.first else {
                print("[DEBUG]: Не удалось получить placemark")
                return
            }

            // Создаем MKPlacemark и MKMapItem
            let mkPlacemark = MKPlacemark(placemark: placemark)
            let mkMapItem = MKMapItem(placemark: mkPlacemark)

            // Добавляем в mapItems
            mapItems = [mkMapItem]

        } catch {
            print("[DEBUG]: Ошибка геокодинга: \(error)")
        }
    }

}

private extension MKCoordinateRegion {

    static let bmstuRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 55.76603817707461,
            longitude: 37.685015762493904
        ),
        latitudinalMeters: 300,
        longitudinalMeters: 300
    )
}
