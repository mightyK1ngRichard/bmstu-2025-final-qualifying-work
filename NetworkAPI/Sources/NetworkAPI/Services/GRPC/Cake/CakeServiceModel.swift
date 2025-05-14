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
    public enum FetchCategoriesByGenderName {}
    public enum FetchCategoryCakes {}
    public enum AddCakeColors {}
}

// MARK: - CreateCategory

public extension CakeServiceModel.CreateCategory {
    struct Request: Sendable {
        let name: String
        let imageData: Data
        let genderTags: [CategoryGender]

        public init(name: String, imageData: Data, genderTags: [CategoryGender]) {
            self.name = name
            self.imageData = imageData
            self.genderTags = genderTags
        }
    }

    struct Response: Sendable {
        public let category: CategoryEntity
    }
}

// MARK: - AddCakeColors

public extension CakeServiceModel.AddCakeColors {
    struct Request: Sendable {
        let cakeID: String
        let hexStrings: [String]

        public init(cakeID: String, hexStrings: [String]) {
            self.cakeID = cakeID
            self.hexStrings = hexStrings
        }
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
        let description: String
        let mass: Double
        let isOpenForSale: Bool
        let discountEndTime: Date?
        let discountKgPrice: Double?
        let fillingIDs: [String]
        let categoryIDs: [String]
        let imagesData: [Data]

        public init(
            name: String,
            previewImageData: Data,
            kgPrice: Double,
            description: String,
            mass: Double,
            isOpenForSale: Bool,
            discountEndTime: Date?,
            discountKgPrice: Double?,
            fillingIDs: [String],
            categoryIDs: [String],
            imagesData: [Data]
        ) {
            self.name = name
            self.previewImageData = previewImageData
            self.kgPrice = kgPrice
            self.description = description
            self.mass = mass
            self.isOpenForSale = isOpenForSale
            self.discountKgPrice = discountKgPrice
            self.discountEndTime = discountEndTime
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

// MARK: - FetchCategoriesByGenderName

public extension CakeServiceModel.FetchCategoriesByGenderName {
    struct Response: Sendable {
        public let categories: [CategoryEntity]
    }
}

// MARK: - FetchCategoryCakes

public extension CakeServiceModel.FetchCategoryCakes {
    struct Response: Sendable {
        public let cakes: [ProfilePreviewCakeEntity]
    }
}
