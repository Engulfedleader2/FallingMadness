//
//  SettingsScene.swift
//  FallingMadness
//
//  Created by Israel on 7/31/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isSoundOn") private var isSoundOn: Bool = true
    @AppStorage("isMusicOn") private var isMusicOn: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Sound", isOn: $isSoundOn)
                Toggle("Music", isOn: $isMusicOn)
            }
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Back"){
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
