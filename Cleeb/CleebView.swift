//
//  ContentView.swift
//  Cleeb
//
//  Created by Eliseo Martelli on 16/08/24.
//

import SwiftUI

struct CleebView: View {
    @State var viewModel = CleebViewModel()
    var body: some View {
        VStack {
            if viewModel.isCleaningModeEnabled {
                ZStack{}.alwaysOnTop()
            }
            Image(nsImage: NSImage(named: "AppIcon")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
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
}
#Preview() {
    CleebView()
}
