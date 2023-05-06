//
//  SwiftUIDarkModeApp.swift
//  SwiftUIDarkMode
//
//  Created by Jet Lye on 06/05/2023.
//

import SwiftUI

@main
struct SwiftUIDarkModeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceChanged), name: UserDefaults.didChangeNotification, object: nil)
        return true
    }
    
    @objc func appearanceChanged() {
    }
}
