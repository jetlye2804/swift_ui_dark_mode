//
//  SwiftUIDarkModeApp.swift
//  SwiftUIDarkMode
//
//  Created by Jet Lye on 06/05/2023.
//

import SwiftUI

@main
struct SwiftUIDarkModeApp: App {
    @StateObject var appearanceManager = AppearanceManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appearanceManager)
        }
    }
}
