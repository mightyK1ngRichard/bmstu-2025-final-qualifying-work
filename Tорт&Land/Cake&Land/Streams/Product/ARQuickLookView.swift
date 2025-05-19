//
//  ARQuickLookView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 04.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI
import QuickLook
import Combine
import DesignSystem
import Core

struct ARQuickRemoteLook: View {
    let remoteURL: URL
    @State private var arQuickLookURL: URL?
    @State private var state: ScreenState = .initial

    var body: some View {
        content.task {
            do {
                state = .loading
                let localURL = try await downloadUSDZ(from: remoteURL)
                arQuickLookURL = localURL
                state = .finished
            } catch {
                state = .error(
                    content: AlertContent(
                        title: StringConstants.failedFetch3DModel,
                        message: "\(error.localizedDescription)"
                    )
                )
            }
        }
    }

    private func downloadUSDZ(from url: URL) async throws -> URL {
        let fileName = url.lastPathComponent + ".usdz"
        let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        // Если файл уже существует, возвращаем его
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            Logger.log("Файл 3D модели уже существует: \(destinationURL)")
            return destinationURL
        }

        // Скачивание из сети
        let (tempURL, _) = try await URLSession.shared.download(from: url)

        do {
            try FileManager.default.moveItem(at: tempURL, to: destinationURL)
            Logger.log("Файл 3D модели загружен и перемещён в: \(destinationURL)")
            return destinationURL
        } catch {
            throw error
        }
    }
}

// MARK: - UI Subviews

private extension ARQuickRemoteLook {
    @ViewBuilder
    var content: some View {
        switch state {
        case .initial, .loading:
            ProgressView()
        case .finished:
            if let modelURL = arQuickLookURL {
                ARQuickLookView(modelURL: modelURL)
            }
        case let .error(content):
            TLErrorView(configuration: .init(from: content))
                .padding()
        }
    }
}

// MARK: - ARQuickLookView -

struct ARQuickLookView: UIViewControllerRepresentable {
    let modelURL: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: - Coordinator

extension ARQuickLookView {
    final class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: ARQuickLookView

        init(_ parent: ARQuickLookView) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            parent.modelURL as NSURL
        }
    }
}
