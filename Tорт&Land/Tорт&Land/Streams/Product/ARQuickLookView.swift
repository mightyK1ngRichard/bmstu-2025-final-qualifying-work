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

struct RemoteARQuickLookView: View {
    let remoteURL: URL
    @State private var localURL: URL?
    @State private var isLoading = false
    @State private var error: Error?

    var body: some View {
        Group {
            if let localURL = localURL {
                ARQuickLookView(modelURL: localURL)
            } else if isLoading {
                ProgressView()
            } else if let error = error {
                Text("Error: \(error.localizedDescription)")
            } else {
                Text("Preparing 3D viewer...")
                    .onAppear(perform: downloadFile)
            }
        }
    }

    private func downloadFile() {
        Task { @MainActor in
            do {
                isLoading = true
                error = nil

                let (tempURL, _) = try await URLSession.shared.download(from: remoteURL)

                // Move to permanent location
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let permanentURL = documentsURL.appendingPathComponent(remoteURL.lastPathComponent)

                try? FileManager.default.removeItem(at: permanentURL) // Remove if exists
                try FileManager.default.moveItem(at: tempURL, to: permanentURL)

                localURL = permanentURL
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }
}

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

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//            let item = ARQuickLookPreviewItem(fileAt: parent.modelURL)
////            item.previewItemContentType = UTType.usdz.identifier
//            item.previewItemContentType = "com.apple.quicklook.usdz"
//            return item
            parent.modelURL as NSURL
        }
    }
}

// Custom preview item class
class ARQuickLookPreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle: String?
    var previewItemContentType: String?

    init(fileAt url: URL) {
        previewItemURL = url
        previewItemTitle = url.lastPathComponent
    }
}
