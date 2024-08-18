//
//  Accessibility.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 16/08/24.
//

import Cocoa
import Foundation
import Combine
import ApplicationServices
import SwiftUI

public extension View {
    func checkAccessability(interval: TimeInterval, access: Binding<Bool>) -> some View {
        self.modifier( AccessabilityCheckModifier(interval: interval, access: access) )
    }
    
    func checkAcessabilityOnAppear(access: Binding<Bool>) -> some View {
        self.onAppear{
            access.wrappedValue = AXIsProcessTrusted()
        }
    }
    
}

public struct AccessabilityCheckModifier: ViewModifier {
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var access: Bool
    
    init(interval: TimeInterval, access: Binding<Bool>) {
        self.timer = Timer.publish(every: interval, on: .current, in: .common).autoconnect()
        _access = access
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(timer) { _ in
                let privAccess = AXIsProcessTrusted()
                if self.access != privAccess {
                    self.access = privAccess
                }
            }
    }
}

func acquireAccessibilityPrivileges() -> Bool {
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    let enabled = AXIsProcessTrustedWithOptions(options)
    return enabled
}

func openAccessibilityPreferences() {
    let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
    NSWorkspace.shared.open(url)
}
