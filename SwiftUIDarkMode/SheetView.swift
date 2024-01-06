//
//  SheetView.swift
//  SwitchToTheDarkSide
//
//  Created by Jet Lye on 15/10/2023.
//

import SwiftUI

struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        NavigationStack {
            AppearanceSelectionPicker()
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
               dismiss()
            }) {
               Text("Done").bold()
            })
        }.interactiveDismissDisabled()
    }
}
