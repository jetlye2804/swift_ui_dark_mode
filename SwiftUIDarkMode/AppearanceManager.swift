//
//  AppearanceManager.swift
//  SwitchToTheDarkSide
//
//  Created by Jet Lye on 15/10/2023.
//

import SwiftUI

class AppearanceManager: ObservableObject {
    @AppStorage("userInterfaceStyle") var userInterfaceStyle: Int?
    
    @Published var selectedAppearance: Appearance = .system

    func initAppearanceStyle() {
        
        // Deprecated in iOS 15.0
        // UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified;
        
        // Method 1
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
        
        // Method 2
//        var appliedStyle: UIUserInterfaceStyle = .unspecified;
//        
//        switch userInterfaceStyle {
//            case 0:
//                appliedStyle = .unspecified
//            case 1:
//                appliedStyle = .light
//            case 2:
//                appliedStyle = .dark
//            default:
//                appliedStyle = .unspecified
//        }
//        
//        
//        UIApplication
//            .shared
//            .connectedScenes
//            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
//            .first{ $0.isKeyWindow }?.window?.overrideUserInterfaceStyle = appliedStyle
    }
    
    func applyAppearanceStyle(_ selectedAppearance: Appearance) {
        switch selectedAppearance {
            case .system:
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
                selectedAppearance = .system
            case 1:
                selectedAppearance = .light
            case 2:
                selectedAppearance = .dark
            default:
                selectedAppearance = .system
        }
    }
}

