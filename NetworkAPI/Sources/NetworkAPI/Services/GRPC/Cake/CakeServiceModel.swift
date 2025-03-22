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
    public enum FetchFillings {}
    public enum FetchCategories {}
    public enum FetchCakes {}
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
        public let category: CategoryEntity
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
        public let filling: FillingEntity
    }
}

// MARK: - FetchFillings

public extension CakeServiceModel.FetchFillings {
    struct Response: Sendable {
        public let fillings: [FillingEntity]
    }
}

// MARK: - FetchCategories

public extension CakeServiceModel.FetchCategories {
    struct Response: Sendable {
        public let categories: [CategoryEntity]
    }
}

// MARK: - CreateCake

public extension CakeServiceModel.CreateCake {
    struct Request: Sendable {
        let name: String
        let previewImageData: Data
        let kgPrice: Double
        let rating: Int
        let description: String
        let mass: Double
        let isOpenForSale: Bool
        let fillingIDs: [String]
        let categoryIDs: [String]
        let imagesData: [Data]

        public init(
            name: String,
            previewImageData: Data,
            kgPrice: Double,
            rating: Int,
            description: String,
            mass: Double,
            isOpenForSale: Bool,
            fillingIDs: [String],
            categoryIDs: [String],
            imagesData: [Data]
        ) {
            self.name = name
            self.previewImageData = previewImageData
            self.kgPrice = kgPrice
            self.rating = rating
            self.description = description
            self.mass = mass
            self.isOpenForSale = isOpenForSale
            self.fillingIDs = fillingIDs
            self.categoryIDs = categoryIDs
            self.imagesData = imagesData
        }
    }

    struct Response: Sendable {
        public let cakeID: String
    }
}

// MARK: - FetchCakes

public extension CakeServiceModel.FetchCakes {
    struct Response: Sendable {
        public let cakes: [PreviewCakeEntity]
    }
}
