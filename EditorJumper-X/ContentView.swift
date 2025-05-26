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

            Text("在 Xcode 中使用 Editor → EditorJumper → 菜单命令")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 10) {
                Text("可用命令:")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 5) {
                    Text("• Open in Cursor - 在 Cursor 中打开当前文件")
                    Text("• Open Settings - 打开设置页面")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            Button {
                print("Button pressed")
                viewModel.openInCursor()
            } label: {
                Text("测试跳转到 Cursor")
                    .padding()
                    .cornerRadius(8)
            }

            Button {
                viewModel.showingSettings = true
            } label: {
                Text("设置")
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
                appState.shouldShowSettings = false // 重置状态
            }
        }
    }
}

#Preview {
    ContentView()
}
