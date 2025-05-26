//
//  AppConfiguration.swift
//  EditorJumperForXcodeXPCService
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
} 