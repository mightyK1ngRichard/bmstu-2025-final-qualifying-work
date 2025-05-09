//
//  TLImageView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI
import Core

public struct TLImageView: View, Configurable {
    let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public var body: some View {
        GeometryReader { geo in
            imageView
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}

// MARK: - UI Subviews

private extension TLImageView {

    @ViewBuilder
    var imageView: some View {
        switch configuration.imageState {
        case .loading:
            ShimmeringView()
        case let .fetched(imageKind):
            getImage(imageKind: imageKind)
        case let .error(errorKind):
            errorImage(kind: errorKind)
        case .empty:
            emptyView
        @unknown default:
            fatalError("unknown case")
        }
    }

    @ViewBuilder
    func getImage(imageKind: ImageState.ImageKind) -> some View {
        switch imageKind {
        case let .uiImage(uiImage):
            getImage(uiImage: uiImage)
        case let .data(imageData):
            getImage(imageData: imageData)
        @unknown default:
            fatalError("unknown case")
        }
    }

    func getImage(uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: configuration.contentMode)
    }

    @ViewBuilder
    func getImage(imageData: Data) -> some View {
        if let uiImage = UIImage(data: imageData) {
            getImage(uiImage: uiImage)
        } else {
            emptyView
        }
    }

    @ViewBuilder
    func errorImage(kind: ImageState.ImageErrorKind) -> some View {
        switch kind {
        case let .uiImage(uiImage):
            getImage(uiImage: uiImage)
        case let .systemImage(systemName):
            emptyView.overlay {
                Image(systemName: systemName)
            }
        }
    }

    var emptyView: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        ForEach([
            TLImageView.Configuration.init(imageState: .fetched(.uiImage(.cake2))),
            .init(
                imageState: .fetched(
                    .data(UIImage(resource: .cake1).pngData() ?? Data())
                )
            ),
            .init(imageState: .loading),
            .init(imageState: .empty),
            .init(imageState: .error(.systemImage()))
        ], id: \.hashValue) { configuration in
            TLImageView(configuration: configuration)
                .frame(height: 200)
                .clipShape(.rect(cornerRadius: 16))
                .padding(.horizontal)
        }
    }
    .background(.bar)
}
