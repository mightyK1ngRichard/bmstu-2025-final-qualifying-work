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

public protocol NetworkService: Sendable {
    func performAndLog<Request, Response: Sendable, MappedResponse>(
        call: (Request, CallOptions?) async throws -> Response,
        with: Request,
        options: CallOptions,
        showRequestLog: Bool,
        showResponseLog: Bool,
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
        showRequestLog: Bool = false,
        showResponseLog: Bool = false,
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        mapping: (Response) -> MappedResponse
    ) async throws -> MappedResponse {
        try await performAndLog(
            call: call,
            with: request,
            options: options,
            showRequestLog: showRequestLog,
            showResponseLog: showResponseLog,
            fileName: fileName,
            function: function,
            line: line,
            mapping: mapping
        )
    }
}

// MARK: - NetworkServiceImpl

public final class NetworkServiceImpl: NetworkService, @unchecked Sendable {
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
        showRequestLog: Bool = false,
        showResponseLog: Bool = false,
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        mapping: (Response) -> MappedResponse
    ) async throws -> MappedResponse {
        Logger.log(showRequestLog ? "💛 Request:\n\(request)" : "💛 Request", fileName: fileName, function: function, line: line)

        do {
            let allOptions = createCallOptions(additional: options)
            let res = try await call(request, allOptions)

            Logger.log(showResponseLog ? "💚 Response:\n\(res)" : "💚 Response")
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
