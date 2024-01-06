//
//  SwiftUIDarkModeApp.swift
//  SwiftUIDarkMode
//
//  Created by Jet Lye on 06/05/2023.
//

import SwiftUI

@main
struct SwiftUIDarkModeApp: App {
    @State var appearanceManager = AppearanceManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appearanceManager)
                .onAppear {
                    appearanceManager.initAppearanceStyle()
                }
            
        }
    }
}
