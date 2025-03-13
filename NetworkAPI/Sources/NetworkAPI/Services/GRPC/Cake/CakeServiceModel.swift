//
//  CakeServiceModel.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 13.03.2025.
//

import Foundation

public enum CakeServiceModel {
    public enum CreateCategory {}
}

public extension CakeServiceModel.CreateCategory {
    struct Request: Sendable {
        let name: String
        let imageData: Data

        public init(name: String, imageData: Data) {
            self.name = name
            self.imageData = imageData
        }
    }

    struct Response: Sendable {
        public let id: String
        public let name: String
        public let imageURL: String
    }
}
