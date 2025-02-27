//
//  AnyTransition+Extensions.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 23.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

extension AnyTransition {

    static let flip: AnyTransition = .modifier(
        active: FlipTransaction(progress: -1),
        identity: FlipTransaction()
    )

    static let reverseFlip: AnyTransition = .modifier(
        active: FlipTransaction(progress: 1),
        identity: FlipTransaction()
    )
}
