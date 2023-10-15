//
//  AppearanceManager.swift
//  SwitchToTheDarkSide
//
//  Created by Jet Lye on 15/10/2023.
//

import SwiftUI

class AppearanceManager: ObservableObject {
    @AppStorage("userInterfaceStyle") var userInterfaceStyle: Int?
    
    @Published var selectedAppearance: Appearance = .automatic

    func initAppearanceStyle() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        windowScene?.windows.forEach { window in
            switch userInterfaceStyle {
                case 0:
                    window.overrideUserInterfaceStyle = .unspecified
                case 1:
                    window.overrideUserInterfaceStyle = .light
                case 2:
                    window.overrideUserInterfaceStyle = .dark
                default:
                    window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
    
    func applyAppearanceStyle(_ selectedAppearance: Appearance) {
        switch selectedAppearance {
            case .automatic:
                userInterfaceStyle = 0
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .unspecified
                    }
                }
            case .light:
                userInterfaceStyle = 1
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            case .dark:
                userInterfaceStyle = 2
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .dark
                    }
                }
        }
    }
    
    func setInitialSelectedAppearance() {
        switch userInterfaceStyle {
            case 0:
                selectedAppearance = .automatic
            case 1:
                selectedAppearance = .light
            case 2:
                selectedAppearance = .dark
            default:
                selectedAppearance = .automatic
        }
    }
}

