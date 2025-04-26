//
//  UserLocationView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import MapKit

struct UserLocationView: View {
    @State var viewModel = UserLocationViewModel()
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var locationManager = LocationManager()
    @State var lookAroundScene: MKLookAroundScene?
    @Namespace var locationSpace

    var body: some View {
        mainContainer.onFirstAppear {
//            viewModel.setEnvironmentObjects(coordinator: coordinator)
            focusOnUserLocation()
        }
    }

    private func focusOnUserLocation() {
        locationManager.requestLocationAccess()
        locationManager.getCurrentLocation()

        if let coordinate = locationManager.userLocation, CLLocationCoordinate2DIsValid(coordinate) {
            withAnimation {
                position = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    UserLocationView(
        viewModel: UserLocationViewModel()
    )
    .environment(Coordinator())
}
