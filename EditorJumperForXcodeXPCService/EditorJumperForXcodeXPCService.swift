//
//  EditorJumperForXcodeXPCService.swift
//  EditorJumperForXcodeXPCService
//
//  Created by user on 2025/5/25.
//

import AppKit
import Foundation

/// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
class EditorJumperForXcodeXPCService: NSObject, EditorJumperForXcodeXPCServiceProtocol {
    // MARK: - EditorJumperForXcodeXPCServiceProtocol
    
    @objc func getCurrentFilePath(with reply: @escaping (String?, Error?) -> Void) {
        let appleScript = """
        tell application "Xcode"
            try
                set lastWord to word -1 of (get name of window 1)
                set currentDoc to document 1 whose name ends with lastWord
                set docPath to path of currentDoc
                return docPath
            on error errMsg
                return "Error: " & errMsg
            end try
        end tell
        """
        
        DispatchQueue.global(qos: .userInitiated).async {
            var error: NSDictionary?
            let script = NSAppleScript(source: appleScript)
            
            guard let script = script else {
                print("XPC Service: Failed to create AppleScript")
                DispatchQueue.main.async {
                    reply(nil, NSError(domain: "EditorJumperError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create AppleScript"]))
                }
                return
            }
            
            print("XPC Service: AppleScript created, executing...")
            let result = script.executeAndReturnError(&error)
            
            DispatchQueue.main.async {
                if let error = error {
                    print("XPC Service: AppleScript error: \(error)")
                    
                    // 检查权限相关错误
                    var errorMessage = "AppleScript execution failed"
                    if let errorDict = error as? [String: Any],
                       let errorNumber = errorDict["NSAppleScriptErrorNumber"] as? Int
                    {
                        switch errorNumber {
                        case -1743:
                            errorMessage = "Permission denied. Please grant automation permission to EditorJumper-X in System Preferences > Security & Privacy > Privacy > Automation"
                        case -1728:
                            errorMessage = "Xcode is not running or not found"
                        default:
                            errorMessage = "AppleScript error: \(errorNumber)"
                        }
                    }
                    
                    reply(nil, NSError(domain: "EditorJumperError", code: 2, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                } else if let stringValue = result.stringValue {
                    print("XPC Service: AppleScript result: \(stringValue)")
                    reply(stringValue, nil)
                } else {
                    print("XPC Service: AppleScript returned no result")
                    reply(nil, NSError(domain: "EditorJumperError", code: 3, userInfo: [NSLocalizedDescriptionKey: "No result from AppleScript"]))
                }
            }
        }
    }
    
    private func openInCursor(filePath: String, line: Int, column: Int, with reply: @escaping (Bool, Error?, String?) -> Void) {
        print("XPC Service: Opening in Cursor - \(filePath):\(line):\(column)")
        
        let task = Process()
        task.launchPath = "/usr/local/bin/cursor"
        task.arguments = [
            "-g", "\(filePath):\(line):\(column)",
        ]
            
        do {
            try task.run()
            task.waitUntilExit()
                
            if task.terminationStatus == 0 {
                print("XPC Service: Successfully opened file in Cursor")
                reply(true, nil, "/usr/local/bin/cursor -g \(filePath):\(line):\(column)")
            } else {
                print("XPC Service: Failed to open file in Cursor, exit code: \(task.terminationStatus)")
                reply(false, NSError(domain: "EditorJumperError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to open Cursor"]), nil)
            }
        } catch {
            print("XPC Service: Error launching Cursor: \(error)")
            reply(false, error, nil)
        }
    }
    
    @objc func jumpToCursor(line: Int, column: Int, with reply: @escaping (Bool, Error?, String?) -> Void) {
        print("XPC Service: Jump to Cursor called - line: \(line), column: \(column)")
        
        getCurrentFilePath { [weak self] filePath, error in
            if let error = error {
                print("XPC Service: Failed to get file path: \(error)")
                reply(false, error, nil)
                return
            }
            
            guard let filePath = filePath, !filePath.isEmpty else {
                print("XPC Service: No file path received")
                reply(false, NSError(domain: "EditorJumperError", code: 5, userInfo: [NSLocalizedDescriptionKey: "No file path available"]), nil)
                return
            }
            
            print("XPC Service: Got file path: \(filePath)")
            
            self?.openInCursor(filePath: filePath, line: line, column: column) { success, error, log in
                reply(success, error, log)
            }
        }
    }
    
    func getProjectPath(_ filePath: String) -> String {
        let fileURL = URL(fileURLWithPath: filePath)
        var currentURL = fileURL.deletingLastPathComponent()
        
        let projectIndicators = [
            "xcodeproj", // Xcode poject file
            "xcworkspace", // Xcode workspace file
        ]
        
        // 向上遍历目录，直到找到包含项目标识文件的目录
        while currentURL.path != "/" {
            let fileManager = FileManager.default
            
            do {
                let contents = try fileManager.contentsOfDirectory(at: currentURL, includingPropertiesForKeys: nil)
                
                // 检查当前目录是否包含项目标识文件
                for item in contents {
                    let fileName = item.lastPathComponent
                    let fileExtension = item.pathExtension
                    
                    // 检查文件扩展名（如 .xcodeproj, .xcworkspace）
                    if projectIndicators.contains(fileExtension) {
                        return currentURL.path
                    }
                    
                    // 检查特定文件名（如 Package.swift, Podfile 等）
                    if projectIndicators.contains(fileName) {
                        return currentURL.path
                    }
                }
                
                // 如果没找到，继续向上一级目录查找
                currentURL = currentURL.deletingLastPathComponent()
            } catch {
                print("Error reading directory: \(error)")
                break
            }
        }
        
        // 如果没找到项目文件，返回原文件所在目录
        return fileURL.deletingLastPathComponent().path
    }
}
