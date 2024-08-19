//
//  PreventSleep.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 18/08/24.
//

import Foundation
import IOKit.pwr_mgt

struct PreventSleep {
    private static var assertionID: IOPMAssertionID = 0
    private static var success: IOReturn?
    
    static func disableSleep() -> Bool? {
        guard success == nil else { return nil }
        success = IOPMAssertionCreateWithName(
            kIOPMAssertionTypeNoDisplaySleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            "Preventing sleep for keyboard cleaning." as CFString,
            &assertionID)
        return success == kIOReturnSuccess
    }
    
    static func enableSleep() -> Bool {
        if success != nil {
            success = IOPMAssertionRelease(assertionID)
            success = nil
            return true
        }
        return false
    }
}
