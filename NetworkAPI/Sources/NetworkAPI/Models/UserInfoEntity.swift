//
//  UserInfoEntity.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 10.04.2025.
//

import Foundation

public struct UserInfoEntity: Sendable, Hashable {
    public let previewCakes: [ProfilePreviewCakeEntity]
    public let profile: ProfileEntity
}
