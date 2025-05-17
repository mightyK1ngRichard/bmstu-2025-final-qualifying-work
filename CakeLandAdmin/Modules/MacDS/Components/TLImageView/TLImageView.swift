//
//  TLImageView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 21.12.2024.
//

import SwiftUI
import MacCore

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
            Rectangle()
                .fill(Color(.secondarySystemFill))
                .overlay {
                    ProgressView()
                        .controlSize(.mini)
                }
        case let .nsImage(nsImage):
            getImage(nsImage: nsImage)
        case let .error(message):
            errorImage(message: message)
        @unknown default:
            fatalError("unknown case")
        }
    }

    func getImage(nsImage: NSImage) -> some View {
        Image(nsImage: nsImage)
            .resizable()
            .aspectRatio(contentMode: configuration.contentMode)
    }

    @ViewBuilder
    func errorImage(message: String) -> some View {
        Rectangle()
            .fill(Color(.secondarySystemFill))
            .overlay {
                Image(systemName: "arrow.trianglehead.2.clockwise")
            }
    }

}

// MARK: - Preview

#Preview {
    TLImageView(configuration: .init(imageState: .loading))
        .padding(100)
}
