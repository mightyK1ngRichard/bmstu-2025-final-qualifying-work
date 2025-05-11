//
//  IconDataSource.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 09.05.2025.
//  Copyright © 2025 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

public enum TLAssets {
    // Chat icons
    public static let checkMark2 = UIImage(resource: .checkMark2)
    public static let paperClip = UIImage(resource: .paperClip)
    public static let profile = UIImage(resource: .profile)
    public static let record = UIImage(resource: .record)
    public static let tgLayer = UIImage(resource: .tgLayer)

    // Common icons
    public static let noConnection = UIImage(resource: .noConnection)
    public static let banner = UIImage(resource: .banner)

    public static let basketIcon = UIImage(resource: .basketIcon)
    public static let cakeLogo = UIImage(resource: .cakeLogo)
    public static let chevronLeft = UIImage(resource: .chevronLeft)
    public static let chevronRight = UIImage(resource: .chevronRight)
    public static let favoriteBorder = UIImage(resource: .favoriteBorder)
    public static let favoritePressed = UIImage(resource: .favoritePressed)
    public static let filter = UIImage(resource: .filter)
    public static let magnifier = UIImage(resource: .magnifier)
    public static let pen = UIImage(resource: .pen)
    public static let sort = UIImage(resource: .sort)
    public static let starFill = UIImage(resource: .starFill)
    public static let starOutline = UIImage(resource: .starOutline)
}

#if DEBUG
public enum TLPreviewAssets {
    // Cakes
    public static let cake1 = UIImage(resource: .cake1)
    public static let cake2 = UIImage(resource: .cake2)
    public static let cake3 = UIImage(resource: .cake3)

    // Categories
    public static let categ1 = UIImage(resource: .categ1)
    public static let categ2 = UIImage(resource: .categ2)
    public static let categ3 = UIImage(resource: .categ3)
    public static let categ4 = UIImage(resource: .categ4)
    public static let categ5 = UIImage(resource: .categ5)

    // Fillings
    public static let filling1 = UIImage(resource: .filling1)
    public static let filling2 = UIImage(resource: .filling2)

    // Avatars
    public static let king = UIImage(resource: .king)
    public static let user1 = UIImage(resource: .user1)
    public static let user2 = UIImage(resource: .user2)
    public static let user3 = UIImage(resource: .user3)
    public static let user4 = UIImage(resource: .user4)
    public static let user5 = UIImage(resource: .user5)
    public static let user6 = UIImage(resource: .user6)
    public static let user7 = UIImage(resource: .user7)

    // Headers
    public static let header1 = UIImage(resource: .header1)
    public static let header2 = UIImage(resource: .header2)
    public static let header3 = UIImage(resource: .header3)
    public static let header5 = UIImage(resource: .header5)
    public static let header6 = UIImage(resource: .header6)
    public static let headerKing = UIImage(resource: .headerKing)
}
#endif
