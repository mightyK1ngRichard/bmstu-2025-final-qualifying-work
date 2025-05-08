//
//  Error+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 06.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import Foundation
import GRPC

extension Error {
    var readableGRPCMessage: String {
        (self as? GRPCStatus)?.message ?? "\(self)"
    }
}
