//
//  AnotherView.swift
//  SwiftUIDarkMode
//
//  Created by Jet Lye on 15/10/2023.
//

import SwiftUI

struct AnotherView: View {
    var body: some View {
        let selectedDisplayMode: NavigationBarItem.TitleDisplayMode = .large
        let navigationTitle: String = "Another"
        
        Text("Text123")
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(selectedDisplayMode)
    }
}
