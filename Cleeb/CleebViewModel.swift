//
//  CleebViewModel.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 16/08/24.
//

import Foundation
import AppKit
import Cocoa
import Quartz

@Observable
class CleebViewModel {
    private let eventMask = CGEventMask((1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue))
    private var eventTap: CFMachPort?  = nil
    
    init() {
        eventTap = CGEvent.tapCreate(tap: .cghidEventTap,
                                     place: .headInsertEventTap,
                                     options: .defaultTap,
                                     eventsOfInterest: eventMask,
                                     callback: { proxy, type, event, refcon in
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            print("Key pressed: \(keyCode)")
            return nil
        }, userInfo: nil)
    }
    
    var _isCleaningModeEnabled: Bool = false
    var isCleaningModeEnabled: Bool {
        get {
            return _isCleaningModeEnabled
        }
        set {
            _isCleaningModeEnabled = newValue
            if newValue {
                if let eventTap = eventTap {
                    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
                    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
                    CGEvent.tapEnable(tap: eventTap, enable: true)
                    CFRunLoopRun()
                }
                return
            }
            
            if let eventTap = eventTap {
                CGEvent.tapEnable(tap: eventTap, enable: false)
                print("Event tap disabled")
            }
        }
    }
}
