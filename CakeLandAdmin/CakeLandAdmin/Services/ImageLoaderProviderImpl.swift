//
//  ImageLoaderProviderImpl.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import Foundation
import AppKit
import MacCore

final actor ImageLoaderProviderImpl {
    private let session: URLSession
    private var imageCache = NSCache<NSString, NSData>()
    private let fileManager: FileManagerImageHash

    init(
        session: URLSession = .shared,
        fileManager: FileManagerImageHash = .shared
    ) {
        self.session = session
        self.fileManager = fileManager
    }
}

extension ImageLoaderProviderImpl {

    func fetchImage(for urlString: String) async -> ImageState {
        // Если есть в кэше, возвращаем
        if let imageData = imageCache.object(forKey: urlString as NSString),
           let nsImage = NSImage(data: imageData as Data) {
            Logger.log("Достал изображние из кэша")
            return .nsImage(nsImage)
        }

        // Если есть в файловом хранилище
        if let imageData = try? await fileManager.loadImage(with: urlString),
           let nsImage = NSImage(data: imageData) {
            Logger.log("Достал изображние из файлового хранилища")
            return .nsImage(nsImage)
        }

        do {
            guard let url = URL(string: urlString) else {
                throw ImageLoaderError.badURL
            }

            let (imageData, _) = try await session.data(for: URLRequest(url: url))

            // Кэшируем
            Task {
                imageCache.setObject(imageData as NSData, forKey: urlString as NSString)
                try await fileManager.save(imageData: imageData, with: urlString)
            }

            guard let nsImage = NSImage(data: imageData) else {
                throw ImageLoaderError.DataIsNil
            }

            return .nsImage(nsImage)
        } catch {
            Logger.log(kind: .error, "Ошибка загрузки изображения: \(error)")
            return .error(error.localizedDescription)
        }
    }

}

// MARK: - ImageLoaderError

extension ImageLoaderProviderImpl {

    enum ImageLoaderError: Error {
        case badURL
        case DataIsNil
    }

}
