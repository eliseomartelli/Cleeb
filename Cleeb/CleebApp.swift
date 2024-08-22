//
//  CleebApp.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 16/08/24.
//

import SwiftUI
import AppKit

@main
struct CleebApp: App {
    @State var isPermitted: Bool = true
    @State var showAlert: Bool = false
    
    var body: some Scene {
        Window("Cleeb", id: "cleeb") {
            CleebView()
                .alert(isPresented: $showAlert, content: accessibilityAlert)
                .checkAccessibility(interval: 1, isPermitted: $isPermitted)
                .onChange(of: isPermitted) {
                    showAlert = !isPermitted && !showAlert
                }
        }
        .windowResizability(.contentSize)
    }
    
    let accessibilityAlert: () -> Alert = {
        Alert(
            title: Text("Cleeb requires Accessibility Permissions"),
            message: Text("""
Cleeb needs to access Accessibility API in order to lock the keyboard while \
cleaning.
Please open System Preferences > Security & Privacy > Accessibility and make \
sure Cleeb has Accessibility Permissions.
"""),
            primaryButton: Alert.Button.default(
                Text("Open Settings"),
                action: {
                    AccessibilityUtils.openAccessibilitySettings()
                }),
            secondaryButton: Alert.Button.cancel(Text("Dismiss"))
        )
    }
}
