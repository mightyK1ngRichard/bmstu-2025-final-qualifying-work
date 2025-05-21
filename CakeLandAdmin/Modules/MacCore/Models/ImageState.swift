//
//  ImageState.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 12.05.2025.
//

import AppKit

public enum ImageState: Hashable {
    case loading
    case nsImage(NSImage)
    case error(String)
}
