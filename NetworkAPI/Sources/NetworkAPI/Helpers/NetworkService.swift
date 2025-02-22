//
//  NetworkService.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import GRPC

// MARK: - NetworkService

public protocol NetworkService {
    func performAndLog<Request, Response: Sendable, MappedResponse>(
        call: (Request, CallOptions?) async throws -> Response,
        with: Request,
        options: CallOptions,
        fileName: String,
        function: String,
        line: Int,
        mapping: (Response) -> MappedResponse
    ) async throws -> MappedResponse

    var callOptions: CallOptions { get set }
}

extension NetworkService {
    func performAndLog<Request, Response: Sendable, MappedResponse>(
        call: (Request, CallOptions?) async throws -> Response,
        with request: Request,
        options: CallOptions = CallOptions(),
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        mapping: (Response) -> MappedResponse
    ) async throws -> MappedResponse {
        try await performAndLog(
            call: call,
            with: request,
            options: options,
            fileName: fileName,
            function: function,
            line: line,
            mapping: mapping
        )
    }
}

// MARK: - NetworkServiceImpl

public final class NetworkServiceImpl: NetworkService {
    private let lock = NSLock()
    private var _callOptions: CallOptions
    public var callOptions: CallOptions {
        get { lock.withLock { _callOptions } }
        set { lock.withLock { _callOptions = newValue } }
    }

    @MainActor
    public required init() {
        self._callOptions = ConfigProvider.makeDefaultCallOptions()
    }

    public func performAndLog<Request, Response: Sendable, MappedResponse>(
        call: (Request, CallOptions?) async throws -> Response,
        with request: Request,
        options: CallOptions = CallOptions(),
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        mapping: (Response) -> MappedResponse
    ) async throws -> MappedResponse {
        Logger.log("💛 Request:\n\(request)", fileName: fileName, function: function, line: line)
        do {
            let allOptions = createCallOptions(additional: options)
            let res = try await call(request, allOptions)
            Logger.log("💚 Response:\n\(res)")
            return mapping(res)
        } catch {
            Logger.log(kind: .error, "❤️ Error:\n\(error)")
            throw error
        }
    }

    private func createCallOptions(additional: CallOptions) -> CallOptions {
        var options = callOptions
        additional.customMetadata.forEach {
            options.customMetadata.replaceOrAdd(name: $0.name, value: $0.value)
        }
        return options
    }
}
