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
        VStack(spacing: 0) {
            header
            
            Divider()
                .padding(.vertical, 24)
            
            // Instructions Section
            VStack(spacing: 20) {
                howToUseSection
                availableCommandsSection
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 12) {
                Button {
                    viewModel.showingSettings = true
                } label: {
                    HStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .sheet(isPresented: $viewModel.showingSettings) {
            SettingsView()
        }
        .onChange(of: appState.shouldShowSettings) { shouldShow in
            if shouldShow {
                viewModel.showingSettings = true
                appState.shouldShowSettings = false
            }
        }
    }
    
    var header: some View {
        VStack(spacing: 16) {
            // App Icon and Title
            HStack(spacing: 12) {
                Image("Logo")
                    .resizable()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Editor Jumper")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("for Xcode")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Description
            Text("Seamlessly jump between Xcode and Cursor editor")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Version
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                Text("Version \(version)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .opacity(0.7)
                    .padding(.top, 4)
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
    }
    
    var howToUseSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("How to install?")
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                InstructionRow(
                    icon: "1.circle",
                    text: "Open System Settings",
                    color: .secondary,
                    action: {
                        if let url = URL(string: "x-apple.systempreferences:com.apple.LoginItems-Settings.extension") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                )
                
                InstructionRow(
                    icon: "2.circle",
                    text: "In \"General\", click on \"Login Items & Extensions\"",
                    color: .secondary
                )
                
                InstructionRow(
                    icon: "3.circle",
                    text: "Below \"Extensions\", click the ⓘ next to \"Xcode Source Editor\"",
                    color: .secondary
                )
                
                InstructionRow(
                    icon: "4.circle",
                    text: "Ensure the checkbox next to \"SwiftFormat for Xcode\" is checked",
                    color: .secondary
                )
                
                InstructionRow(
                    icon: "5.circle",
                    text: "Relaunch Xcode",
                    color: .secondary
                )
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    var availableCommandsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "command.circle.fill")
                    .foregroundColor(.purple)
                Text("Available Commands")
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
            }
            
            VStack(spacing: 8) {
                CommandRow(
                    icon: "cursorarrow.rays",
                    title: "Open in Cursor",
                    description: "Open current file in Cursor editor"
                )
                
                CommandRow(
                    icon: "gearshape.fill",
                    title: "Open Settings",
                    description: "Configure Cursor path and preferences"
                )
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - Helper Views

struct InstructionRow: View {
    let icon: String
    let text: String
    let color: Color
    let action: (() -> Void)?
    
    init(icon: String, text: String, color: Color, action: (() -> Void)? = nil) {
        self.icon = icon
        self.text = text
        self.color = color
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            if action != nil {
                Button("Open") {
                    action?()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
    }
}

struct CommandRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
