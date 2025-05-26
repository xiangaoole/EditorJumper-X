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
                    print("Button pressed")
                    viewModel.openInCursor()
                } label: {
                    HStack {
                        Image(systemName: "cursorarrow.rays")
                        Text("Test Jump to Cursor")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
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
        .onChange(of: appState.shouldShowSettings) { _, shouldShow in
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
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.accentColor)
                
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
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
    }
    
    var howToUseSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("How to Use")
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                InstructionRow(
                    icon: "1.circle.fill",
                    text: "Open any file in Xcode",
                    color: .blue
                )
                
                InstructionRow(
                    icon: "2.circle.fill",
                    text: "Go to Editor → EditorJumper menu",
                    color: .green
                )
                
                InstructionRow(
                    icon: "3.circle.fill",
                    text: "Select \"Open in Cursor\" command",
                    color: .orange
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
