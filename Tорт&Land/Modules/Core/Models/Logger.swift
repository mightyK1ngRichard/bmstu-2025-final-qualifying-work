//
//  Logger.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 11.02.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

public final class Logger {
    private init() {}

    public static func log(
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

    public enum Kind: String, Hashable {
        case info  = "ℹ️ info"
        case error = "⛔️ error"
        case debug = "⚙️ debug"
        case image = "💿 image"
        case warning = "⚠️ warning"
    }
}
