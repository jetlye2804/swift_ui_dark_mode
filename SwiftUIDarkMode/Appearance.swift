//
//  Appearance.swift
//  SwitchToTheDarkSide
//
//  Created by Jet Lye on 15/10/2023.
//

import SwiftUI

enum Appearance: LocalizedStringKey, CaseIterable, Identifiable {
    case light
    case dark
    case automatic

    var id: String { UUID().uuidString }
}
