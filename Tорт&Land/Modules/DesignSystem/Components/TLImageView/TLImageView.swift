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
    var didTapReloadImage: TLStringBlock?

    public init(configuration: Configuration, didTapReloadImage: TLStringBlock? = nil) {
        self.configuration = configuration
        self.didTapReloadImage = didTapReloadImage
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
        case let .error(url, icon):
            if didTapReloadImage == nil {
                errorImage(icon: icon)
            } else {
                errorImage(icon: icon)
                    .contentShape(.rect)
                    .onTapGesture {
                        if let url {
                            didTapReloadImage?(url)
                        }
                    }
            }
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
    func errorImage(icon: ImageState.ImageIcon) -> some View {
        switch icon {
        case let .uiImage(uiImage):
            getImage(uiImage: uiImage)
        case let .systemImage(systemName):
            emptyView.overlay {
                Image(systemName: systemName)
                    .foregroundStyle(.secondary)
            }
        @unknown default:
            fatalError("unknown case")
        }
    }

    var emptyView: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
    }
}

// MARK: - Preview
#if DEBUG
import Core

#Preview {
    ScrollView {
        ForEach([
            TLImageView.Configuration.init(imageState: .fetched(.uiImage(TLPreviewAssets.cake2))),
            .init(
                imageState: .fetched(
                    .data(TLPreviewAssets.cake1.pngData() ?? Data())
                )
            ),
            .init(imageState: .loading),
            .init(imageState: .empty),
            .init(imageState: .error("mock link", .systemImage()))
        ], id: \.hashValue) { configuration in
            TLImageView(configuration: configuration) { url in
                print("[DEBUG]: reload image: \(url ?? "none")")
            }
            .frame(height: 200)
            .clipShape(.rect(cornerRadius: 16))
            .padding(.horizontal)
        }
    }
    .background(.bar)
}
#endif
