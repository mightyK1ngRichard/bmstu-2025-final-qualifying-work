//
//  Error+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 06.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import GRPC
import NIO

extension Error {
    var readableGRPCContent: AlertContent {
        // 1. Обработка GRPC ошибок
        if let status = self as? GRPCStatus {
            switch status.code {
            case .unavailable, .deadlineExceeded:
                return .init(
                    title: "Сервер недоступен",
                    message: "Пожалуйста, проверьте подключение к интернету или повторите попытку позже."
                )
            default:
                return .init(
                    title: "Ошибка",
                    message: status.message ?? "Произошла неизвестная ошибка."
                )
            }
        }

        // 2. Ошибки NIO при подключении
        let description = String(describing: self)
        if description.contains("Connection refused") || description.contains("SingleConnectionFailure") {
            return .init(
                title: "Сервер отключён",
                message: "Приложению не удалось подключиться к серверу. Убедитесь, что сервер работает, и повторите попытку."
            )
        }

        // 3. Ошибка по умолчанию
        return .init(
            title: "Неизвестная ошибка",
            message: description
        )
    }
}
