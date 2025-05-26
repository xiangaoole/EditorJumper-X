//
//  AppConfiguration.swift
//  EditorJumper-X
//
//  Created by user on 2025/5/26.
//

import Foundation

/// Application configuration management class, using App Group shared UserDefaults
class AppConfiguration {
    static let shared = AppConfiguration()
    
    private let appGroupIdentifier = "group.com.haroldgao.EditorJumper-X"
    private let userDefaults: UserDefaults
    
    // MARK: - Keys
    private enum Keys {
        static let cursorPath = "cursorPath"
    }
    
    // MARK: - Default Values
    private enum DefaultValues {
        static let cursorPath = "/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
    }
    
    private init() {
        if let groupDefaults = UserDefaults(suiteName: appGroupIdentifier) {
            self.userDefaults = groupDefaults
        } else {
            // If App Group is not available, fallback to standard UserDefaults
            self.userDefaults = UserDefaults.standard
            print("⚠️ App Group UserDefaults not available, using standard UserDefaults")
        }
    }
    
    // MARK: - Cursor Path Configuration
    
    /// Get Cursor executable file path
    var cursorPath: String {
        get {
            return userDefaults.string(forKey: Keys.cursorPath) ?? DefaultValues.cursorPath
        }
        set {
            userDefaults.set(newValue, forKey: Keys.cursorPath)
        }
    }
    
    /// Reset Cursor path to default value
    func resetCursorPathToDefault() {
        cursorPath = DefaultValues.cursorPath
    }
    
    /// Validate if Cursor path is valid
    func validateCursorPath(_ path: String) -> (isValid: Bool, message: String?) {
        guard !path.isEmpty else {
            return (false, "Path cannot be empty")
        }
        
        let fileManager = FileManager.default
        
        // Check if file exists
        guard fileManager.fileExists(atPath: path) else {
            return (false, "File does not exist: \(path)")
        }
        
        // Check if file is executable
        guard fileManager.isExecutableFile(atPath: path) else {
            return (false, "File is not executable: \(path)")
        }
        
        return (true, "✅ Path is valid")
    }
    
    /// Common Cursor installation paths
    static let commonCursorPaths = [
        "/usr/local/bin/cursor",
        "/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
    ]
    
    /// Auto-detect Cursor path
    func autoDetectCursorPath() -> String? {
        for path in Self.commonCursorPaths {
            if FileManager.default.isExecutableFile(atPath: path) {
                return path
            }
        }
        return nil
    }
} 