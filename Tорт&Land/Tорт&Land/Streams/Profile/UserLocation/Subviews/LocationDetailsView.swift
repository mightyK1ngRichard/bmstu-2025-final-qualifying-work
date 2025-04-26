//
//
//  LocationDetailsView.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 13.05.2024.
//  Copyright 2024 © VK Team CakesHub. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    var action: TLGenericBlock<MKMapItem>?

    var body: some View {
        VStack {
            HeaderBlock

            LookAroundSceneView

            ButtonsBlock
        }
        .padding(.top)
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { _, newValue in
            fetchLookAroundPreview()
        }
    }
}

// MARK: - Network

private extension LocationDetailsView {

    func fetchLookAroundPreview() {
        guard let mapSelection else { return }
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: mapSelection)
            do {
                lookAroundScene = try await request.scene
            } catch {
                Logger.log(kind: .error, error.localizedDescription)
            }
        }
    }
}

// MARK: - UI Subviews

private extension LocationDetailsView {

    var HeaderBlock: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(mapSelection?.placemark.name ?? "")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(mapSelection?.placemark.title ?? "")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
                    .padding(.trailing)
            }

            Spacer()

            Button(action: {
                mapSelection = nil
                withAnimation {
                    show = false
                }
            }, label: {
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white, .ultraThinMaterial)
            })
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    var LookAroundSceneView: some View {
        if let scene = lookAroundScene {
            LookAroundPreview(initialScene: scene)
                .frame(height: 200)
                .clipShape(.rect(cornerRadius: 12))
                .padding()
        } else {
            ContentUnavailableView("No preview available", systemImage: "eye.slash")
        }
    }

    var ButtonsBlock: some View {
        HStack {
            Button(action: {
                guard let mapSelection else { return }
                mapSelection.openInMaps()
            }, label: {
                Text("Open in map")
                    .buttonStyle(color: Color(.systemGray3))
            })

            Button(action: {
                if let mapSelection {
                    action?(mapSelection)
                }
                withAnimation {
                    show = false
                }
            }, label: {
                Text("Select")
                    .buttonStyle(color: .blue)
            })
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    LocationDetailsView(
        mapSelection: .constant(nil),
        show: .constant(true)
    )
}

// MARK: - Helper

private extension Text {

    func buttonStyle(color: Color) -> some View {
        style(18, .semibold, TLColor<TextPalette>.textPrimary.color)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .clipShape(.rect(cornerRadius: 12))
    }
}
