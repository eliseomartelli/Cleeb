//
//  EventListener.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 18/08/24.
//

import Cocoa

class EventListener {
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    
    init() {
        let eventMask = CGEventMask(
            (1 << NX_KEYUP) |
            (1 << NX_KEYDOWN) |
            (1 << NX_SYSDEFINED) // Should caputer media hotkeys.
        )
        self.eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { _, _, _, _ in
                return nil // Don't deliver the event to the system.
            }, userInfo: nil)
    }
    
    func startListening() {
        guard let eventTap else {
            return
        }
        runLoopSource = CFMachPortCreateRunLoopSource(
            /* allocator: */
            kCFAllocatorDefault,
            /* port: */
            eventTap,
            // This value is currently ignored by CFMachPort run loop sources.
            // And eventTap type is CFMachPort.
            // I'm passing 0 according to the documentation.
            0
        )
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }
    
    func stopListening() {
        guard let runLoopSource else {
            return
        }
        CFRunLoopRemoveSource(
            CFRunLoopGetCurrent(),
            runLoopSource,
            .commonModes)
        
        guard let eventTap else {
            return
        }
        CGEvent.tapEnable(tap: eventTap, enable: false)
    }
    
    deinit {
        self.runLoopSource = nil
        self.eventTap = nil
    }
}
