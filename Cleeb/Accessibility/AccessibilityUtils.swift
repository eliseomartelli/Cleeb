//
//  AccessibilityUtils.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 18/08/24.
//

import Cocoa

struct AccessibilityUtils {
    static func requestAccessibilityPermissions() -> Bool {
        let options = [
            kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true
        ] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
    
    static func openAccessibilitySettings() {
        let url = URL(string: """
x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility
""")
        NSWorkspace.shared.open(url!)
    }
}
