//
//  OnTopModifier.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 18/08/24.
//

import SwiftUI

struct OnTopModifier: ViewModifier {
    @State private var previousWindowLevel: NSWindow.Level? = nil
    func body(content: Content) -> some View {
        content
            .onAppear {
                if let window = NSApplication.shared.windows.first {
                    self.previousWindowLevel = window.level
                    window.level = .floating
                }
            }
            .onDisappear {
                if let window = NSApplication.shared.windows.first {
                    if let previousLevel = previousWindowLevel {
                        window.level = previousLevel
                    }
                }
            }
    }
}

extension View {
    func alwaysOnTop() -> some View {
        self.modifier(OnTopModifier())
    }
}
