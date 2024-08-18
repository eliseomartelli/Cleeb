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
                // TODO: refactor always on top to accept a binding to avoid using this hacky code.
                ZStack{}.alwaysOnTop()
            }
            VStack(alignment: .leading) {
                VStack(alignment: .center) {
                    Image(nsImage: NSImage(named: "AppIcon")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Toggle(isOn: $viewModel.isCleaningModeEnabled) {
                        Text("Cleaning Mode")
                    }
                    .toggleStyle(.switch)
                }
                .frame(maxWidth: .infinity)
                Spacer()
                Text("Cleaning Mode disables all keyboard input, preventing you from typing anything until it is turned off.")
                    .font(.subheadline)
            }
            .padding()
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    CleebView()
}
