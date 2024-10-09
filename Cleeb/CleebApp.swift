//
//  CleebApp.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 16/08/24.
//

import SwiftUI
import AppKit

enum ActiveAlert {
    case accessibility
    case update
}

@main
struct CleebApp: App {
    @State var isPermitted: Bool = true
    @State var showAlert: Bool = false
    @State var activeAlert: ActiveAlert = .accessibility
    
    @StateObject private var versionViewModel = VersionViewModel()
    
    var body: some Scene {
        Window("Cleeb", id: "cleeb") {
            CleebView()
                .environmentObject(versionViewModel)
                .onAppear(perform: checkForUpdate)
                .alert(isPresented: $showAlert, content: activeAlertContent)
                .checkAccessibility(interval: 1, isPermitted: $isPermitted)
                .onChange(of: isPermitted) {
                    handleAccessibilityChange()
                }
                .onChange(of: versionViewModel.latestVersion) {
                    checkForUpdate()
                }
        }
        .windowResizability(.contentSize)
    }
    
    // MARK: - Methods
    
    private func checkForUpdate() {
        if Bundle.main.buildVersion! != versionViewModel.latestVersion {
            activeAlert = .update
            showAlert = true
        }
    }
    
    private func activeAlertContent() -> Alert {
        switch activeAlert {
        case .accessibility:
            return accessibilityAlert()
        case .update:
            return updateAlert()
        }
    }
    
    
    private func handleAccessibilityChange() {
        showAlert = !isPermitted && !showAlert
        if showAlert {
            activeAlert = .accessibility
        }
    }
    
    
    private let accessibilityAlert: () -> Alert = {
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
    
    private let updateAlert: () -> Alert = {
        Alert(
            title: Text("Cleeb is out of date"),
            message: Text("Please update Cleeb to the latest version."),
            primaryButton: Alert.Button.default(
                Text("Open GitHub"),
                action: {
                    let url = URL(string: "https://github.com/eliseomartelli/Cleeb/releases")!
                    NSWorkspace.shared.open(url)
                }),
            secondaryButton: Alert.Button.cancel(Text("Dismiss"))
        )
    }
}
