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
    @State var permitted: Bool = false
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ZStack{}.checkAccessability(interval: 1, access: $permitted)
            if permitted {
                CleebView()
            } else {
                PermissionView()
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        _ = acquireAccessibilityPrivileges()
        
        if let window = NSApplication.shared.windows.first {
            window.level = .floating
        }
    }
}
