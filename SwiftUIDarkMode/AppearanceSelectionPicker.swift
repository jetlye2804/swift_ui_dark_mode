//
//  AppearanceSelectionPicker.swift
//  SwitchToTheDarkSide
//
//  Created by Jet Lye on 15/10/2023.
//

import SwiftUI

struct AppearanceSelectionPicker: View {
    @EnvironmentObject var appearanceManager: AppearanceManager

    var body: some View {
        List {
            ForEach(Appearance.allCases, id: \.self) { appearance in
                Button(action: {
                    appearanceManager.selectedAppearance = appearance
                }) {
                    HStack {
                        Text(appearance.rawValue)
                        Spacer()
                        if appearance == appearanceManager.selectedAppearance {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }

        .onChange(of: appearanceManager.selectedAppearance, perform: { value in
            appearanceManager.applyAppearanceStyle(value)
        })
        .onAppear {
            appearanceManager.setInitialSelectedAppearance()
        }
    }
}

