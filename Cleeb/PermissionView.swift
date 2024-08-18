//
//  PermissionView.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 16/08/24.
//

import SwiftUI

struct PermissionView: View {
    var body: some View {
        VStack {
            Text("This application requires Accessibilty Permissions")
                .font(.title2)
                .fontWeight(.bold)
            Text("Cleeb requires Accessibility Permissions for the Cleaning Mode.")
            Button(action: {
                openAccessibilityPreferences()
            }, label: {
                Text("Open Settings")
            })
        }
        .padding()
    }
}

#Preview {
    PermissionView()
}
