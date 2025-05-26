//
//  AppConfiguration.swift
//  EditorJumperForXcodeXPCService
//
//  Created by user on 2025/5/26.
//

import Foundation

/// 应用配置管理类，使用App Group共享UserDefaults
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
            // 如果App Group不可用，回退到标准UserDefaults
            self.userDefaults = UserDefaults.standard
            print("⚠️ App Group UserDefaults not available, using standard UserDefaults")
        }
    }
    
    // MARK: - Cursor Path Configuration
    
    /// 获取Cursor可执行文件路径
    var cursorPath: String {
        get {
            return userDefaults.string(forKey: Keys.cursorPath) ?? DefaultValues.cursorPath
        }
        set {
            userDefaults.set(newValue, forKey: Keys.cursorPath)
        }
    }
} 