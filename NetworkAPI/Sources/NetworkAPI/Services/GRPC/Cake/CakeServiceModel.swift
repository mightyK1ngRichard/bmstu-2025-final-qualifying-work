//
//  CakeServiceModel.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 13.03.2025.
//

import Foundation

public enum CakeServiceModel {
    public enum CreateCake {}
    public enum CreateCategory {}
    public enum CreateFilling {}
    public enum FetchFilling {}
    public enum FetchCategories {}
}

// MARK: - CreateCategory

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

// MARK: - CreateFilling

public extension CakeServiceModel.CreateFilling {
    struct Request: Sendable {
        let name: String
        let imageData: Data
        let content: String
        let kgPrice: Double
        let description: String

        public init(
            name: String,
            imageData: Data,
            content: String,
            kgPrice: Double,
            description: String
        ) {
            self.name = name
            self.imageData = imageData
            self.content = content
            self.kgPrice = kgPrice
            self.description = description
        }
    }

    struct Response: Sendable {
        public let id: String
        public let name: String
        public let imageURL: String
        public let content: String
        public let kgPrice: Double
        public let description: String
    }
}

// MARK: - FetchFilling

public extension CakeServiceModel.FetchFilling {
    struct Response: Sendable {
        public let id: String
        public let name: String
        public let imageURL: String
        public let content: String
        public let kgPrice: Double
        public let description: String
    }
}

// MARK: - FetchCategories

public extension CakeServiceModel.FetchCategories {
    struct Response: Sendable {
        public let id: String
        public let name: String
        public let imageURL: String
    }
}

// MARK: - CreateCake

public extension CakeServiceModel.CreateCake {
    struct Request: Sendable {
        let name: String
        let imageData: Data
        let kgPrice: Double
        let rating: Int
        let description: String
        let mass: Double
        let isOpenForSale: Bool
        let fillingIDs: [String]
        let categoryIDs: [String]

        public init(
            name: String,
            imageData: Data,
            kgPrice: Double,
            rating: Int,
            description: String,
            mass: Double,
            isOpenForSale: Bool,
            fillingIDs: [String],
            categoryIDs: [String]
        ) {
            self.name = name
            self.imageData = imageData
            self.kgPrice = kgPrice
            self.rating = rating
            self.description = description
            self.mass = mass
            self.isOpenForSale = isOpenForSale
            self.fillingIDs = fillingIDs
            self.categoryIDs = categoryIDs
        }
    }

    struct Response: Sendable {
        public let cakeID: String
    }
}
