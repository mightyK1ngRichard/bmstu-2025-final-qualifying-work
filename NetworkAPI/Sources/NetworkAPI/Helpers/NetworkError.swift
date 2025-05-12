//
//  NetworkError.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 16.03.2025.
//

import Foundation

public enum NetworkError: Error {
    case missingAccessToken
    case missingRefreshToken
}
