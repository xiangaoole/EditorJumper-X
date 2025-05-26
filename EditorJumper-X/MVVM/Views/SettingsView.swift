//
//  SettingsView.swift
//  EditorJumper-X
//
//  Created by user on 2025/5/26.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            Divider()
            
            ScrollView {
                VStack(spacing: 24) {
                    cursorPathSection
                    commonPathsSection
                }
                .padding(24)
            }
            
            Divider()
            
            footerSection
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            viewModel.loadCurrentPath()
        }
    }
    
    var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Configure Cursor editor path")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
    }
    
    var cursorPathSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "folder.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
                
                Text("Cursor Path Configuration")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Cursor Executable Path:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 8) {
                    TextField("Enter path to Cursor executable", text: $viewModel.cursorPath)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(.body, design: .monospaced))
                        .onChange(of: viewModel.cursorPath) {
                            viewModel.validateCurrentPath()
                        }
                    
                    Button("Browse...") {
                        viewModel.browseCursorPath()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Auto Detect") {
                        viewModel.autoDetectCursorPath()
                    }
                    .buttonStyle(.bordered)
                }
                
                if let validationMessage = viewModel.validationMessage {
                    HStack(spacing: 6) {
                        Image(systemName: viewModel.isPathValid ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .foregroundColor(viewModel.isPathValid ? .green : .orange)
                        
                        Text(validationMessage)
                            .font(.caption)
                            .foregroundColor(viewModel.isPathValid ? .green : .orange)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    var commonPathsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "list.bullet")
                    .foregroundColor(.purple)
                    .font(.title3)
                
                Text("Common Installation Locations")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            
            VStack(spacing: 8) {
                ForEach(viewModel.commonPaths, id: \.self) { path in
                    CommonPathRow(
                        path: path,
                        isFound: FileManager.default.isExecutableFile(atPath: path),
                        onUse: {
                            viewModel.cursorPath = path
                            viewModel.saveCursorPath()
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    var footerSection: some View {
        HStack {
            Button("Reset to Default") {
                viewModel.resetToDefault()
            }
            .buttonStyle(.bordered)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Button("Save") {
                    viewModel.saveCursorPath()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isPathValid)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
    }
}

// MARK: - Helper Views

struct CommonPathRow: View {
    let path: String
    let isFound: Bool
    let onUse: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isFound ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isFound ? .green : .red)
                .font(.caption)
            
            Text(path)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.middle)
            
            Spacer()
            
            if isFound {
                Button("Use") {
                    onUse()
                }
                .buttonStyle(.borderless)
                .font(.caption)
                .foregroundColor(.blue)
            } else {
                Text("Not Found")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.textBackgroundColor))
        .cornerRadius(8)
    }
}

#Preview {
    SettingsView()
}
