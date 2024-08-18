//
//  View+checkAccessibility.swift
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
    internal func checkAccessibility(
        interval: TimeInterval,
        isPermitted: Binding<Bool>
    ) -> some View {
        self.modifier(AccessibilityCheckModifier(
            interval: interval, isPermitted: isPermitted
        ))
    }
}

/// A view modifier that periodically checks an accessibility condition and updates a binding to indicate whether a permission is granted.
///
/// The `AccessibilityCheckModifier` is designed to periodically check an accessibility-related condition, such as whether an app is trusted for accessibility purposes.
/// It uses a timer to trigger these checks at regular intervals and updates a binding variable based on the result of the check.
///
/// - Parameters:
///   - interval: The time interval in seconds between each accessibility check.
///   - isPermitted: A binding to a `Bool` that indicates whether the accessibility permission is granted.
///
/// ## Example Usage
/// ```swift
/// struct ContentView: View {
///     @State private var isPermitted: Bool = false
///
///     var body: some View {
///         Text("Accessibility Check")
///             .modifier(AccessibilityCheckModifier(interval: 5.0, isPermitted: $isPermitted))
///     }
/// }
/// ```
///
/// In this example, `isPermitted` will be updated every 5 seconds based on the result of the accessibility check.
///
/// ## Implementation Details
/// - The modifier uses a `Timer` publisher that autoconnects to the current run loop and triggers an accessibility check at the specified interval.
/// - When the view appears, the modifier immediately performs an initial check.
/// - The result of the accessibility check is stored in the `isPermitted` binding.
///
/// ## See Also
/// - `ViewModifier`
/// - `Timer.TimerPublisher`
/// - `AccessibilityModel`
public struct AccessibilityCheckModifier: ViewModifier {
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    var accessibilityModel = Accessibility()
    @Binding var isPermitted: Bool
    
    init(interval: TimeInterval, isPermitted: Binding<Bool>) {
        self.timer = Timer.publish(
            every: interval, on: .current, in: .common
        ).autoconnect()
        self._isPermitted = isPermitted
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear { updatePermitted() }
            .onReceive(timer) { _ in updatePermitted() }
    }
    
    func updatePermitted() {
        self.isPermitted = accessibilityModel.isTrusted
    }
}
