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
import MapKit

@Observable
final class UserLocationViewModel: UserLocationDisplayLogic, UserLocationViewModelInput, UserLocationViewModelOutput {
    var uiProperties = UserLocationModel.UIProperties()
    var camera: MapCameraPosition = .region(.bmstuRegion)
    var mapSelection: MKMapItem?
    private(set) var mapItems: [MKMapItem] = []
    @ObservationIgnored
    private var coordinator: Coordinator?
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

        print("[DEBUG]: \(selectedMapItem.placemark.title)")
        print("[DEBUG]: \(Double(selectedMapItem.placemark.coordinate.latitude))")
    }

    func setEnvironmentObjects(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

import SwiftUI
#Preview {
    UserLocationView(
        viewModel: UserLocationViewModel()
    )
    .environment(Coordinator())
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
