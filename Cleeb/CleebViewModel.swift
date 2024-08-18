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
    private var eventListenerModel: EventListener = EventListener()
    
    var _isCleaningModeEnabled: Bool = false
    var isCleaningModeEnabled: Bool {
        get {
            return _isCleaningModeEnabled
        }
        set {
            if newValue {
                self.eventListenerModel.startListening()
            } else {
                self.eventListenerModel.stopListening()
            }
            _isCleaningModeEnabled = newValue
        }
    }
}
