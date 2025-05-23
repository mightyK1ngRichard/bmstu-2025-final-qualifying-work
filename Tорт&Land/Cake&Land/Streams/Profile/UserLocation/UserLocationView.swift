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
    @State var viewModel: UserLocationViewModel
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var locationManager = LocationManager()
    @State var lookAroundScene: MKLookAroundScene?
    @Namespace var locationSpace
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(coordinator: coordinator)
            locationManager.requestLocationAccess()
        }
    }
}
