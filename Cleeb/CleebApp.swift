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
    
    var body: some Scene {
        Window("Cleeb", id: "cleeb") {
            CleebView()
                .onAppear {
                    GithubVersionRepository.shared.getVersion { result in
                        switch result {
                        case .success(let version):
                            let toUpdate = Bundle.main.buildVersion! != version
                            if toUpdate {
                                activeAlert = .update
                                showAlert = true
                            }
                            return
                        case .failure(let error):
                            print(error)
                            return
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .accessibility:
                        return accessibilityAlert()
                    case .update:
                        return updateAlert()
                    }
                }
                .checkAccessibility(interval: 1, isPermitted: $isPermitted)
                .onChange(of: isPermitted) {
                    showAlert = !isPermitted && !showAlert
                    if showAlert {
                        activeAlert = .accessibility
                    }
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
    
    let updateAlert: () -> Alert = {
        Alert(title: Text("Cleeb is out of date"), message: Text("Please update Cleeb to the latest version."), primaryButton: Alert.Button.default(Text("Open GitHub"), action: {
            // Open github releases url
            let url = URL(string: "https://github.com/eliseomartelli/Cleeb/releases")!
            // Open the url
            NSWorkspace.shared.open(url)
        }), secondaryButton: Alert.Button.cancel(Text("Dismiss")))
    }
}
