//
//  FileManagerImageHash.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import Foundation
import AppKit
import CommonCrypto

final actor FileManagerImageHash {
    static let shared = FileManagerImageHash()

    private let fileManager = FileManager.default
    private let path: URL?

    private init() {
        let basePath = try? fileManager
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("ImageCache", isDirectory: true)

        do {
            if let basePath = basePath {
                try fileManager.createDirectory(at: basePath, withIntermediateDirectories: true)
                self.path = basePath
            } else {
                self.path = nil
            }
        } catch {
            self.path = nil
            Logger.log(kind: .error, "Failed to create cache directory: \(error)")
        }
    }

    /// Сохраняет изображение с заданным хэшем
    func save(imageData: Data, with key: String) async throws {
        guard let path else {
            throw FileManagerImageHashError.invalidPath
        }

        let hash = imageHash(with: key)
        let fileURL = path.appendingPathComponent(hash)
        try imageData.write(to: fileURL)
    }

    /// Извлекает изображение по хэшу
    func loadImage(with key: String) async throws -> Data {
        guard let path else {
            throw FileManagerImageHashError.invalidPath
        }

        let hash = imageHash(with: key)
        let fileURL = path.appendingPathComponent(hash)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw FileManagerImageHashError.fileNotExists
        }

        let imageData = try Data(contentsOf: fileURL)

        return imageData
    }

}

// MARK: - Helpers

private extension FileManagerImageHash {

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
    }

}
