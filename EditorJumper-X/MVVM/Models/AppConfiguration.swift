//
//  AppConfiguration.swift
//  EditorJumper-X
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
    
    /// 重置Cursor路径为默认值
    func resetCursorPathToDefault() {
        cursorPath = DefaultValues.cursorPath
    }
    
    /// 验证Cursor路径是否有效
    func validateCursorPath(_ path: String) -> (isValid: Bool, message: String?) {
        guard !path.isEmpty else {
            return (false, "路径不能为空")
        }
        
        let fileManager = FileManager.default
        
        // 检查文件是否存在
        guard fileManager.fileExists(atPath: path) else {
            return (false, "文件不存在: \(path)")
        }
        
        // 检查是否为可执行文件
        guard fileManager.isExecutableFile(atPath: path) else {
            return (false, "文件不可执行: \(path)")
        }
        
        return (true, "✅ 路径有效")
    }
    
    /// 常见的Cursor安装路径
    static let commonCursorPaths = [
        "/usr/local/bin/cursor",
        "/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
    ]
    
    /// 自动检测Cursor路径
    func autoDetectCursorPath() -> String? {
        for path in Self.commonCursorPaths {
            if FileManager.default.isExecutableFile(atPath: path) {
                return path
            }
        }
        return nil
    }
} 