//
//  ConfigProvider.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import GRPC
import NIO

final class ConfigProvider: Sendable {
    @MainActor
    static func makeDefaultCallOptions() -> CallOptions {
        let device = "\(SystemInfo.modelName)" + " (\(SystemInfo.systemVersion))"
        let requestId = UUID().uuidString

        return CallOptions(
            customMetadata: [
                StringConst.requestId: requestId,
                StringConst.agent: device,
                StringConst.fingerprint: StringConst.ios,
            ],
            timeLimit: .timeout(.seconds(8))
        )
    }

    static func makeJWTTokens() -> JWTTokens {
        let accessToken = UserDefaults.standard.string(forKey: UserDefaultsKeys.accessToken.rawValue)
        let refreshToken = UserDefaults.standard.string(forKey: UserDefaultsKeys.refreshToken.rawValue)

        return JWTTokens(accessToken: accessToken, refreshToken: refreshToken)
    }

    static func makeConection(
        host: String,
        port: Int,
        numberOfThreads: Int = 1
    ) throws -> GRPCChannel {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)
        let channel = try GRPCChannelPool.with(
            target: .host(host, port: port),
            transportSecurity: .plaintext,
            eventLoopGroup: group
        )

        return channel
    }
}
