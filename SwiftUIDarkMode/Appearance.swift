//
//  Appearance.swift
//  SwiftUIDarkMode
//
//  Created by Jet Lye on 06/05/2023.
//

import SwiftUI

enum Appearance: String, CaseIterable {
    case dark = "Dark"
    case light = "Light"
    case system = "System"

    var colorScheme: ColorScheme? {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            return nil
        }
    }
}

let appearanceKey = "appearanceSelection"
