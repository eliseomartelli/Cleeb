//
//  Bundle+version.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 09/10/24.
//

import Foundation

extension Bundle {
    var buildVersion: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
