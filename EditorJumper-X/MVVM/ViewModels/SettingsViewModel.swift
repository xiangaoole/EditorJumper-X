//
//  SettingsViewModel.swift
//  EditorJumper-X
//
//  Created by user on 2025/5/26.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var cursorPath: String = ""
    @Published var validationMessage: String?
    @Published var isPathValid: Bool = true
    
    private let appConfig = AppConfiguration.shared
    
    var commonPaths: [String] {
        return AppConfiguration.commonCursorPaths
    }
    
    init() {
        loadCurrentPath()
    }
    
    func loadCurrentPath() {
        cursorPath = appConfig.cursorPath
        validateCurrentPath()
    }
    
    func saveCursorPath() {
        appConfig.cursorPath = cursorPath
        validationMessage = "✅ Path saved successfully"
        isPathValid = true
    }
    
    func validateCurrentPath() {
        let result = appConfig.validateCursorPath(cursorPath)
        isPathValid = result.isValid
        validationMessage = result.message
    }
    
    func browseCursorPath() {
        let panel = NSOpenPanel()
        panel.title = "Select Cursor Executable File"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.unixExecutable]
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                cursorPath = url.path
                validateCurrentPath()
            }
        }
    }
    
    func autoDetectCursorPath() {
        if let detectedPath = appConfig.autoDetectCursorPath() {
            cursorPath = detectedPath
            validateCurrentPath()
        } else {
            validationMessage = "❌ Cursor executable file not found"
            isPathValid = false
        }
    }
    
    func resetToDefault() {
        appConfig.resetCursorPathToDefault()
        loadCurrentPath()
    }
}
