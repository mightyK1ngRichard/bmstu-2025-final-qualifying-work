//
//  NetworkService.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//

import Foundation
import GRPC

// MARK: - NetworkService

protocol NetworkService {
    func performAndLog<Request, Response: Sendable, MappedResponse>(
        call: (Request, CallOptions?) async throws -> Response,
        with: Request,
        options: CallOptions,
        fileName: String,
        function: String,
        line: Int,
        mapping: (Response) -> MappedResponse
    ) async throws -> MappedResponse
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

final class NetworkServiceImpl: NetworkService {
    func performAndLog<Request, Response: Sendable, MappedResponse>(
        call: (Request, CallOptions?) async throws -> Response,
        with request: Request,
        options: CallOptions = CallOptions(),
        fileName: String = #file,
        function: String = #function,
        line: Int = #line,
        mapping: (Response) -> MappedResponse
    ) async throws -> MappedResponse {
        Logger.log("Делаю запрос. Request:\n \(request)", fileName: fileName, function: function, line: line)
        let res = try await call(request, options)
        Logger.log("Response: \(res)")
        return mapping(res)
    }
}
