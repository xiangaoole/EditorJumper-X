//
//  EditorJumper_XApp.swift
//  EditorJumper-X
//
//  Created by user on 2025/5/23.
//

import SwiftUI

@main
struct EditorJumper_XApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onAppear {
                    checkForSettingsArgument()
                }
        }
    }
    
    private func checkForSettingsArgument() {
        let arguments = CommandLine.arguments
        if arguments.contains("--show-settings") {
            appState.shouldShowSettings = true
        }
    }
}

class AppState: ObservableObject {
    @Published var shouldShowSettings = false
}
