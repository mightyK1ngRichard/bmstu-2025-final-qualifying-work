//
//  ProfileServiceModel.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 09.04.2025.
//

import Foundation

public enum ProfileServiceModel {
    public enum GetUserInfo {}
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
