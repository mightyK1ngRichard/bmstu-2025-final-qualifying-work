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
    func maybeRefreshAccessToken(using authService: AuthService) async throws
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

    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var callOptions: CallOptions { get set }

    func setAccessToken(_ accessToken: String, expiresIn: Date)
    func setRefreshToken(_ refreshToken: String)
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
    public var accessToken: String? {
        get { lock.withLock { _accessToken } }
        set { lock.withLock { _accessToken = newValue } }
    }
    public var refreshToken: String? {
        get { lock.withLock { _refreshToken } }
        set { lock.withLock { _refreshToken = newValue } }
    }
    public var callOptions: CallOptions {
        get { lock.withLock { _callOptions } }
        set { lock.withLock { _callOptions = newValue } }
    }

    private let lock = NSLock()
    private var _expiresIn: Date? = nil
    private var _accessToken: String? = nil
    private var _refreshToken: String? = nil
    private var _callOptions: CallOptions

    @MainActor
    public required init() {
        let jwtTokens = ConfigProvider.makeJWTTokens()
        self._callOptions = ConfigProvider.makeDefaultCallOptions()
        self._accessToken = jwtTokens.accessToken
        self._refreshToken = jwtTokens.refreshToken
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

    public func setAccessToken(_ accessToken: String, expiresIn: Date) {
        lock.lock()
        self._accessToken = accessToken
        self._expiresIn = expiresIn
        lock.unlock()

        Task { @MainActor in
            UserDefaults.standard.set(accessToken, forKey: UserDefaultsKeys.accessToken.rawValue)
            UserDefaults.standard.set(expiresIn, forKey: UserDefaultsKeys.expiresIn.rawValue)
        }
    }

    public func setRefreshToken(_ refreshToken: String) {
        self.refreshToken = refreshToken

        Task { @MainActor in
            UserDefaults.standard.set(refreshToken, forKey: UserDefaultsKeys.refreshToken.rawValue)
        }
    }

    public func maybeRefreshAccessToken(using authService: AuthService) async throws {
        // Число секунд до истечения, чтобы обновить заранее
        let threshold: TimeInterval = 30

        let shouldRefresh: Bool = lock.withLock {
            guard let expiration = _expiresIn else {
                return true
            }

            return Date() >= expiration.addingTimeInterval(-threshold)
        }

        guard shouldRefresh else { return }

        let response = try await authService.updateAccessToken()
        setAccessToken(response.accessToken, expiresIn: Date(timeIntervalSince1970: TimeInterval(response.expiresIn)))
    }

    private func createCallOptions(additional: CallOptions) -> CallOptions {
        var options = callOptions
        if let accessToken {
            options.customMetadata.add(name: "authorization", value: "Bearer \(accessToken)")
        }
        additional.customMetadata.forEach {
            options.customMetadata.replaceOrAdd(name: $0.name, value: $0.value)
        }
        return options
    }
}
