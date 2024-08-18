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
    var body: some Scene {
        WindowGroup {
            ZStack {
                CleebView()
            }
            .alert(isPresented: !$isPermitted, content: {
                Alert(
                    title: Text("Cleeb requires Accessibility Permissions"),
                    message: Text("""
Cleeb needs to access Accessibility API in order to lock the keyboard while \
cleaning.
Please open System Preferences > Security & Privacy > Accessibility and make \
sure Cleeb has Accessibility Permissions.
"""),
                    primaryButton: Alert.Button.default(
                        Text("Open Settings")
                        , action: {
                            AccessibilityUtils.openAccessibilitySettings()
                        }),
                    secondaryButton: Alert.Button.cancel(
                        Text("Dismiss")
                    )
                )
            })
            .checkAccessibility(interval: 1, isPermitted: $isPermitted)
            .onAppear {
                NSWindow.allowsAutomaticWindowTabbing = false
            }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
            }
        }
        .windowResizability(.contentSize)
    }
}

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
