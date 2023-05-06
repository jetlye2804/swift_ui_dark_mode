//
//  ContentView.swift
//  SwiftUIDarkMode
//
//  Created by Jet Lye on 06/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var currentAppearance: Appearance = {
        guard let savedAppearance = UserDefaults.standard.string(forKey: appearanceKey),
              let appearance = Appearance(rawValue: savedAppearance) else {
            return .system
        }
        return appearance
    }()
    
    @State private var isSheetPresented = false
    @Environment(\.colorScheme) var systemColorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Is it Dark?")
                    .font(.title)
                Text((currentAppearance == .system ? systemColorScheme : currentAppearance.colorScheme) == .dark ? "Yes" : "No")
                    .font(.largeTitle)
                    .bold()
                
                Text("Follow System Settings?")
                    .font(.title)
                Text(currentAppearance == .system ? "Yes" : "No")
                    .font(.largeTitle)
                    .bold()
                
                Button(action: {
                    isSheetPresented = true
                }) {
                    Text("Change Appearance")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("Dark Mode Status")
        }
        .conditionalColorScheme(currentAppearance.colorScheme)
        .sheet(isPresented: $isSheetPresented) {
            AppearanceSelectionView(currentAppearance: $currentAppearance)
        }
    }
}
