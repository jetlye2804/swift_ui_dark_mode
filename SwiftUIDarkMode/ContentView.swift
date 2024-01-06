//
//  ContentView.swift
//  SwitchToTheDarkSide
//
//  Created by Laurent B on 11/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSheet = false
    @Environment(AppearanceManager.self) var appearanceManager: AppearanceManager

    var body: some View {
        
        let selectedDisplayMode: NavigationBarItem.TitleDisplayMode = .large
        let navigationTitle: String = "Home"

        NavigationStack {
            ScrollView {
                NavigationLink {
                    AnotherView()
                } label: {
                    Text("Navigation Link")
                }
                
                VStack {
                    Text("Appearance")
                        .font(.title)
                    Text("From User Defaults")

                    Text(appearanceManager.userInterfaceStyle != nil ? String(appearanceManager.userInterfaceStyle!) : "N/A")
                    
                    Button("Show Sheet") {
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                        SheetView()
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(selectedDisplayMode)
        }
    }
}
