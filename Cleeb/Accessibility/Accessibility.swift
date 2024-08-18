//
//  AccessibilityModel.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 18/08/24.
//

import Cocoa

struct Accessibility {
    var isTrusted: Bool {
        return AXIsProcessTrusted()
    }
}
