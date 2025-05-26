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
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Editor Jumper Settings")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
                    
            GroupBox("Cursor Path Configuration") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Cursor Path:")
                        .font(.headline)
                            
                    HStack {
                        TextField("Cursor executable file path", text: $viewModel.cursorPath)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: viewModel.cursorPath) {
                                viewModel.validateCurrentPath()
                            }
                                
                        Button("Browse") {
                            viewModel.browseCursorPath()
                        }
                                
                        Button("Auto Detect") {
                            viewModel.autoDetectCursorPath()
                        }
                    }
                            
                    if let validationMessage = viewModel.validationMessage {
                        Text(validationMessage)
                            .foregroundColor(viewModel.isPathValid ? .green : .red)
                            .font(.caption)
                    }
                            
                    Text("Common Cursor Installation Locations:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                            
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(viewModel.commonPaths, id: \.self) { path in
                            HStack {
                                Text("• \(path)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                        
                                Spacer()
                                        
                                if FileManager.default.isExecutableFile(atPath: path) {
                                    Button("Use") {
                                        viewModel.cursorPath = path
                                        viewModel.saveCursorPath()
                                    }
                                    .buttonStyle(.borderless)
                                    .font(.caption)
                                } else {
                                    Text("Not Found")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
                    
            HStack {
                Button("Reset to Default") {
                    viewModel.resetToDefault()
                }
                        
                Spacer()
                        
                Button("Save") {
                    viewModel.saveCursorPath()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isPathValid)
            }
                    
            Spacer()
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
        .onAppear {
            viewModel.loadCurrentPath()
        }
    }
}

#Preview {
    SettingsView()
}
