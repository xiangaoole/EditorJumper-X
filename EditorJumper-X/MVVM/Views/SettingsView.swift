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
                Text("Editor Jumper 设置")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("关闭") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
                    
            GroupBox("Cursor 路径配置") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("当前 Cursor 路径:")
                        .font(.headline)
                            
                    HStack {
                        TextField("Cursor 可执行文件路径", text: $viewModel.cursorPath)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: viewModel.cursorPath) {
                                viewModel.validateCurrentPath()
                            }
                                
                        Button("浏览") {
                            viewModel.browseCursorPath()
                        }
                                
                        Button("自动检测") {
                            viewModel.autoDetectCursorPath()
                        }
                    }
                            
                    if let validationMessage = viewModel.validationMessage {
                        Text(validationMessage)
                            .foregroundColor(viewModel.isPathValid ? .green : .red)
                            .font(.caption)
                    }
                            
                    Text("常见 Cursor 安装位置:")
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
                                    Button("使用") {
                                        viewModel.cursorPath = path
                                        viewModel.saveCursorPath()
                                    }
                                    .buttonStyle(.borderless)
                                    .font(.caption)
                                } else {
                                    Text("未找到")
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
                Button("重置为默认") {
                    viewModel.resetToDefault()
                }
                        
                Spacer()
                        
                Button("保存") {
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
