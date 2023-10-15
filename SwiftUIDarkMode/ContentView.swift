//
//  ContentView.swift
//  SwitchToTheDarkSide
//
//  Created by Laurent B on 11/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSheet = false
    @EnvironmentObject var appearanceManager: AppearanceManager

    var body: some View {
        VStack {
            Text("Appearance")
                .font(.title)
            Text("From @AppStorage")
            Text(appearanceManager.userInterfaceStyle != nil ? String(appearanceManager.userInterfaceStyle!) : "N/A")
            
            Button("Show Sheet") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                // No need to pass any parameters to SheetView
                SheetView()
            }
        }
        .onAppear {
            appearanceManager.initAppearanceStyle()
        }
    }
}
