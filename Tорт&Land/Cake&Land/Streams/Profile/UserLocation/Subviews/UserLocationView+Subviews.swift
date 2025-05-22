//
//  UserLocationView+Subviews.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 26.04.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import MapKit
import DesignSystem

extension UserLocationView {

    var mainContainer: some View {
        Map(
            position: $viewModel.camera,
            selection: $viewModel.mapSelection,
            scope: locationSpace
        ) {
            ForEach(viewModel.mapItems, id: \.self) { item in
                let placemark = item.placemark
                Marker(
                    placemark.name ?? "Unknown",
                    systemImage: "building",
                    coordinate: placemark.coordinate
                )
                .tint(.cyan)
            }

            UserAnnotation()
        }
        .navigationBarHidden(true)
        .mapStyle(.imagery)
        .sheet(isPresented: $viewModel.uiProperties.showSheet, onDismiss: {
            viewModel.uiProperties.textInput.removeAll()
        }) {
            streetsView
        }
        .sheet(isPresented: $viewModel.uiProperties.showDetailsSheet) {
            mapDetails
                .presentationDetents([.height(Constants.sheetHeight)])
                .presentationBackgroundInteraction(
                    .enabled(upThrough: .height(Constants.sheetHeight))
                )
                .presentationCornerRadius(12)
                .presentationBackground(.ultraThinMaterial)
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                Task {
                    guard let coordinate = locationManager.userLocation else { return }
                    await viewModel.updateUserLocation(with: coordinate)
                }
            } label: {
                Image(systemName: "location.fill")
                    .padding(14)
            }
            .background(.ultraThinMaterial, in: .circle)
            .buttonBorderShape(.circle)
            .padding()
        }
        .mapScope(locationSpace)
        .overlay(alignment: .top) {
            navigationContainer
        }
        .onChange(of: viewModel.mapSelection) { _, newValue in
            let showDetailsSheet = newValue != nil
            fetchLookAroundView()
            viewModel.uiProperties.showSheet = !showDetailsSheet
            viewModel.uiProperties.showDetailsSheet = showDetailsSheet
        }
    }
}

private extension UserLocationView {

    func fetchLookAroundView() {
        if let mapSelection = viewModel.mapSelection {
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try await request.scene
            }
        }
    }
}

private extension UserLocationView {

    var navigationContainer: some View {
        HStack(spacing: 0) {
            Button(action: viewModel.didTapBackButton, label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .bold()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .padding(.leading)
            })

            TextField(
                Constants.textFieldPlaceholder,
                text: $viewModel.uiProperties.textInput
            )
            .font(.subheadline)
            .tint(.white)
            .padding(12)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
            .shadow(radius: 10)
            .padding(.horizontal)
            .onChange(of: viewModel.uiProperties.textInput, viewModel.didInputText)
        }
    }

    var mapDetails: some View {
        VStack(spacing: 15) {
            ZStack {
                if lookAroundScene != nil {
                    LookAroundPreview(scene: $lookAroundScene)
                } else {
                    ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                }
            }
            .frame(height: 200)
            .clipShape(.rect(cornerRadius: 15))

            TLButton(String(localized: "Select Address").uppercased()) {
                viewModel.didSelectAddress()
            }
        }
        .padding(.horizontal)
    }

    var streetsView: some View {
        List(viewModel.mapItems, id: \.self) { item in
            Button {
                if let coordinate = item.placemark.location?.coordinate {
                    withAnimation {
                        viewModel.camera = .region(MKCoordinateRegion(
                            center: coordinate,
                            latitudinalMeters: 500,
                            longitudinalMeters: 500
                        ))
                    }
                }
            } label: {
                VStack(alignment: .leading) {
                    Text(item.name?.capitalized ?? "Без названия")
                        .font(.headline)
                        .foregroundStyle(TLColor<TextPalette>.textPrimary.color)
                    Text(item.placemark.title ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listRowBackground(Color.clear)
        .presentationDetents([.height(140), .medium])
        .presentationBackground(.ultraThinMaterial)
        .presentationDragIndicator(.visible)
        .scrollContentBackground(.automatic)
        .presentationBackgroundInteraction(.enabled)
        .presentationContentInteraction(.scrolls)
    }
}

// MARK: - Preview

#Preview {
    UserLocationView(
        viewModel: UserLocationViewModel { _ in }
    )
    .environment(Coordinator())
}

// MARK: - Constants

private extension UserLocationView {

    enum Constants {
        static let sheetHeight: CGFloat = 340
        static let textFieldPlaceholder = String(localized: "Search")
        static let locationImg = "location.fill"
        static let backButtonImg = "chevron.left"
    }
}
