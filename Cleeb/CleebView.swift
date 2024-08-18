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
            VStack(alignment: .leading) {
                Spacer()
                Toggle(isOn: $viewModel.isCleaningModeEnabled) {
                    Text("Cleaning Mode")
                }
                .toggleStyle(.switch)
                Text("Cleaning Mode disables all keyboard input, preventing you from typing anything until it is turned off.")
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

#Preview {
    CleebView()
}
