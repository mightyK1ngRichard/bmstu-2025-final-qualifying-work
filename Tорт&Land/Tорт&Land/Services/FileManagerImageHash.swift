//
//  FileManagerImageHash.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 18.03.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import UIKit
import CommonCrypto

protocol FileManagerImageHashProtocol {
    func save(uiImage: UIImage, for key: String)
    func obtain(with key: String) -> UIImage?
}

// MARK: - FileManagerImageHash

final class FileManagerImageHash {

    static let shared = FileManagerImageHash()
    private let fileManager = FileManager.default
    private let saveQueue = DispatchQueue(
        label: "com.vk.FileManagerImageHash.saveImages",
        qos: .utility,
        attributes: [.concurrent]
    )

    private init() {}

}

// MARK: - FileManagerImageHashProtocol

extension FileManagerImageHash: FileManagerImageHashProtocol {

    func save(uiImage: UIImage, for key: String) {
        guard let url = path else {
            return
        }

        let imageURL = url.appendingPathComponent(imageHash(with: key))
        saveQueue.async {
            do {
                guard let data = uiImage.pngData() else {
                    throw FileManagerImageHashError.convertImageToDataFailed
                }

                try data.write(to: imageURL)
            } catch {
                Logger.log(kind: .error, "Ошибка сохранения изображения: \(error.localizedDescription)")
            }
        }
    }

    func obtain(with key: String) -> UIImage? {
        do {
            guard let url = path else {
                throw FileManagerImageHashError.invalidPath
            }

            let imageURL = url.appendingPathComponent(imageHash(with: key))

            guard fileManager.fileExists(atPath: imageURL.path) else {
                throw FileManagerImageHashError.fileNotExists
            }

            let imageData = try Data(contentsOf: imageURL)
            guard let uiImage = UIImage(data: imageData) else {
                throw FileManagerImageHashError.convertDataToImageFailed
            }

            return uiImage
        } catch {
            Logger.log(kind: .error, "Ошибка получения изображения: \(error.localizedDescription)")
            return nil
        }
    }

}

// MARK: - Helpers

private extension FileManagerImageHash {

    var path: URL? {
        try? fileManager.url(for: .cachesDirectory,
                             in: .userDomainMask,
                             appropriateFor: nil,
                             create: true)
    }

    func imageHash(with key: String) -> String {
        let data = Data(key.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = data.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }

        let hash = digest.map { String(format: "%02x", $0) }.joined()
        return hash
    }

}

// MARK: - FileManagerImageHashError

extension FileManagerImageHash {

    enum FileManagerImageHashError: Error {
        case invalidPath
        case fileNotExists
        case convertDataToImageFailed
        case convertImageToDataFailed
    }

}
