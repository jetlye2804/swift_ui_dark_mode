//
//  ConditionalColorScheme.swift
//  SwiftUIDarkMode
//
//  Created by Jet Lye on 06/05/2023.
//

import SwiftUI

struct ConditionalColorScheme: ViewModifier {
    let colorScheme: ColorScheme?

    func body(content: Content) -> some View {
        if let colorScheme = colorScheme {
            return content.colorScheme(colorScheme).eraseToAnyView()
        } else {
            return content.eraseToAnyView()
        }
    }
}

extension View {
    func conditionalColorScheme(_ colorScheme: ColorScheme?) -> some View {
        self.modifier(ConditionalColorScheme(colorScheme: colorScheme))
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

