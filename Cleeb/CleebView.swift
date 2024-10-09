//
//  ContentView.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 16/08/24.
//

import SwiftUI

struct CleebView: View {
    @State var viewModel = CleebViewModel()
    @EnvironmentObject var versionViewModel: VersionViewModel
    
    var body: some View {
        VStack {
            if viewModel.isCleaningModeEnabled {
                ZStack{}.alwaysOnTop()
            }
            ZStack(alignment: .topTrailing) {
                Image(nsImage: NSImage(named: "AppIcon")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                if versionViewModel.isUpdateAvailable {
                    Button {
                        if let url = URL(string: "https://github.com/eliseomartelli/Cleeb/releases") {
                            NSWorkspace.shared.open(url)
                        }
                    }  label: {
                        HStack {
                            Image(systemName: "arrow.down")
                            Text(versionViewModel.latestVersion)
                        }
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .offset(x: -10, y: 10) // Adjust the position of the pill
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Spacer()
            Toggle(isOn: $viewModel.isCleaningModeEnabled) {
                Text("Cleaning mode")
                Text("""
Cleaning mode disables all keyboard input, \
preventing you from typing anything until it is turned off.
""")
            }
            .toggleStyle(.switch)
            .padding()
            .background(.background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 1)
            .padding(.bottom)
        }
        .frame(width: 300, height: 300)
    }
}

#Preview() {
    CleebView()
        .environment(\.locale, .init(identifier: "it"))
        .environmentObject(VersionViewModel())
}

#Preview() {
    CleebView()
        .environmentObject(VersionViewModel())
}
