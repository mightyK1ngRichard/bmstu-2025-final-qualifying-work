//
//  ProfileServiceModel.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 09.04.2025.
//

import Foundation

public enum ProfileServiceModel {
    public enum GetUserInfo {}
    public enum UpdateUser {}
    public enum CreateAddress {}
}

// MARK: - CreateAddress

public extension ProfileServiceModel.CreateAddress {
    struct Request: Sendable {
        let latitude: Double
        let longitude: Double
        let formattedAddress: String

        public init(
            latitude: Double,
            longitude: Double,
            formattedAddress: String
        ) {
            self.latitude = latitude
            self.longitude = longitude
            self.formattedAddress = formattedAddress
        }
    }
}

// MARK: - GetUserInfo

public extension ProfileServiceModel.GetUserInfo {
    struct Response: Sendable {
        public let userInfo: UserInfoEntity

        public init(userInfo: UserInfoEntity) {
            self.userInfo = userInfo
        }
    }
}

// MARK: - UpdateUser

public extension ProfileServiceModel.UpdateUser {
    struct Request: Sendable {
        let addressID: String
        let entrance: String?
        let floor: String?
        let apartment: String?
        let comment: String?

        public init(
            addressID: String,
            entrance: String?,
            floor: String?,
            apartment: String?,
            comment: String?
        ) {
            self.addressID = addressID
            self.entrance = entrance
            self.floor = floor
            self.apartment = apartment
            self.comment = comment
        }
    }

    struct Response: Sendable {
        public let address: AddressEntity

        public init(address: AddressEntity) {
            self.address = address
        }
    }
}
