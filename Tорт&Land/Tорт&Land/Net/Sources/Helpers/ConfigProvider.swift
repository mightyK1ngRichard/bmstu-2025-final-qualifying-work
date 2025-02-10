//
//  ConfigProvider.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//

import Foundation
import GRPC
import NIO

final class ConfigProvider: Sendable {
    static func makeDefaultCallOptions() -> CallOptions {
        let device = "\(SystemInfo.modelName)" + " (\(SystemInfo.systemVersion))"
        let requestId = UUID().uuidString

        return CallOptions(
            customMetadata: [
                StringConst.requestId: requestId,
                StringConst.agent: device,
                StringConst.fingerprint: StringConst.ios,
            ],
            timeLimit: .timeout(.seconds(2))
        )
    }

    static func makeConection(host: String, port: Int, numberOfThreads: Int = System.coreCount) throws -> GRPCChannel {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)
        let channel = try GRPCChannelPool.with(
            target: .host(host, port: port),
            transportSecurity: .plaintext,
            eventLoopGroup: group
        )
        return channel
    }
}
