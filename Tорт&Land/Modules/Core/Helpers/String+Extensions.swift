//
//  String+Extensions.swift
//  Cake&Land
//
//  Created by Dmitriy Permyakov on 11.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation

public extension String {
    
    /// Заменяет все вхождения "localhost" на IP адрес, определенный в конфигурации
    /// - Returns: Строка с замененным "localhost" на IP адрес
    func replaceLocalhost() -> String {
        replacingOccurrences(of: "localhost", with: AppConfig.networkIP)
    }

}
