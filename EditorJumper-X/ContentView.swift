//
//  ContentView.swift
//  EditorJumper-X
//
//  Created by user on 2025/5/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MainViewModel()
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            Text("Editor Jumper for Xcode")
                .font(.title)
                .fontWeight(.bold)

            Text("Use Editor → EditorJumper → menu commands in Xcode")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 10) {
                Text("Available Commands:")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 5) {
                    Text("• Open in Cursor - Open current file in Cursor")
                    Text("• Open Settings - Open settings page")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            Button {
                print("Button pressed")
                viewModel.openInCursor()
            } label: {
                Text("Test Jump to Cursor")
                    .padding()
                    .cornerRadius(8)
            }

            Button {
                viewModel.showingSettings = true
            } label: {
                Text("Settings")
                    .padding()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .sheet(isPresented: $viewModel.showingSettings) {
            SettingsView()
        }
        .onAppear {
//                viewModel.checkForSettingsArgument()
        }
        .onChange(of: appState.shouldShowSettings) { shouldShow in
            if shouldShow {
                viewModel.showingSettings = true
                appState.shouldShowSettings = false // Reset state
            }
        }
    }
}

#Preview {
    ContentView()
}
