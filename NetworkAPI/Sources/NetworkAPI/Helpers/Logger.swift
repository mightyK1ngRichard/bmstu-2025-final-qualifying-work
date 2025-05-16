//
//  Logger.swift
//  NetworkAPI
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//

import Foundation

final class Logger {
    private init() {}

    static func log(
        kind: Kind = .info,
        _ message: Any,
        fileName: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let swiftFileName = fileName.split(separator: "/").last ?? "file not found"
        print("[ \(kind.rawValue.uppercased()) ]: [ \(Date()) ]: [ \(swiftFileName) ] [ \(function) ]: [ #\(line) ]")
        print(message)
        print()
        #endif
    }

    enum Kind: String, Hashable {
        case info  = "ℹ️ info"
        case error = "⛔️ error"
        case debug = "⚙️ debug"
        case warning = "⚠️ warning"
    }
}
