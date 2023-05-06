//
//  AppearanceSelectionView.swift
//  SwiftUIDarkMode
//
//  Created by Jet Lye on 06/05/2023.
//

import SwiftUI

struct AppearanceSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var currentAppearance: Appearance

    var body: some View {
        NavigationView {
            List(Appearance.allCases, id: \.self) { appearance in
                Button(action: {
                    currentAppearance = appearance
                    UserDefaults.standard.set(appearance.rawValue, forKey: appearanceKey)
                }) {
                    HStack {
                        Text(appearance.rawValue)
                        Spacer()
                        if currentAppearance == appearance {
                            Image(systemName: "checkmark")
                                .foregroundColor(.primary)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
            .navigationBarTitle("Appearance Options", displayMode: .inline)
        }
        .conditionalColorScheme(currentAppearance.colorScheme)
    }
}
