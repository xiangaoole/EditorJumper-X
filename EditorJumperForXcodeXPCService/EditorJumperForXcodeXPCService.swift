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
    
    private let appConfig = AppConfiguration.shared
    
    var cursorPath: String {
        return appConfig.cursorPath
    }
    
    @objc func getCurrentFilePath(with reply: @escaping (String?, Error?) -> Void) {
        let appleScript = """
        tell application "Xcode"
            try
                set windowName to name of window 1
                -- Handle Preview mode: remove " — Preview" suffix
                if windowName ends with " — Preview" then
                    set windowName to text 1 thru -12 of windowName
                end if
                -- Handle Edited state: remove " — Edited" suffix
                if windowName ends with " — Edited" then
                    set windowName to text 1 thru -11 of windowName
                end if
                -- Detect special Preview windows
                if windowName ends with " Preview" then
                    return "Error: Cannot get file path from Preview window: " & windowName
                end if
                -- Get filename (last word)
                set fileName to word -1 of windowName
                set currentDoc to document 1 whose name is fileName
                set docPath to path of currentDoc
                return docPath
            on error errMsg2
                return "Error: " & errMsg2
            end try
        end tell
        """
        
        var error: NSDictionary?
        let script = NSAppleScript(source: appleScript)
            
        guard let script = script else {
            print("XPC Service: Failed to create AppleScript")
            reply(nil, NSError(domain: "EditorJumperError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create AppleScript"]))
                
            return
        }
            
        print("XPC Service: AppleScript created, executing...")
        let result = script.executeAndReturnError(&error)
            
        if let error = error {
            print("XPC Service: AppleScript error: \(error)")
                    
            // Check permission-related errors
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
        } else if let stringValue = result.stringValue { // Check if return value starts with "Error", if so treat as error
            if stringValue.hasPrefix("Error:") {
                let errorMessage = String(stringValue.dropFirst(6).trimmingCharacters(in: .whitespaces))
                reply(nil, NSError(domain: "EditorJumperError", code: 4, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
            } else {
                reply(stringValue, nil)
            }
        } else {
            print("XPC Service: AppleScript returned no result")
            reply(nil, NSError(domain: "EditorJumperError", code: 3, userInfo: [NSLocalizedDescriptionKey: "No result from AppleScript"]))
        }
    }
    
    private func openInCursor(filePath: String, line: Int, column: Int, with reply: @escaping (Bool, Error?, String?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Use /usr/bin/open to launch Cursor with arguments in sandbox environment
            let process = Process()
            process.launchPath = "/usr/bin/open"
            
            // Prepare arguments for opening Cursor with specific file and line
            process.arguments = [
                "-a", self.cursorPath,
                "--args",
                "-g", "\(filePath):\(line):\(column)",
                "-a", "\(self.getProjectPath(filePath))"
            ]
            
            do {
                try process.run()
                process.waitUntilExit()
                
                if process.terminationStatus == 0 {
                    let log = "XPC Service: Successfully opened Cursor with \(self.cursorPath) -g \(filePath):\(line):\(column)"
                    print(log)
                    reply(true, nil, log)
                } else {
                    let log = "XPC Service: Failed to open file in Cursor, exit code: \(process.terminationStatus)"
                    print(log)
                    reply(false, NSError(domain: "EditorJumperError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to open Cursor"]), log)
                }
            } catch {
                print("XPC Service: Failed to launch Cursor: \(error.localizedDescription)")
                reply(false, error, nil)
            }
        }
    }
    
    @objc func openInCursor(line: Int, column: Int, with reply: @escaping (Bool, Error?, String?) -> Void) {
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
        while currentURL.path != "/" {
            let fileManager = FileManager.default
            
            do {
                let contents = try fileManager.contentsOfDirectory(at: currentURL, includingPropertiesForKeys: nil)
                
                for item in contents {
                    let fileName = item.lastPathComponent
                    let fileExtension = item.pathExtension
                    
                    if projectIndicators.contains(fileExtension) {
                        return currentURL.path
                    }
                    
                    if projectIndicators.contains(fileName) {
                        return currentURL.path
                    }
                }
                
                currentURL = currentURL.deletingLastPathComponent()
            } catch {
                print("Error reading directory: \(error)")
                break
            }
        }
        
        return fileURL.deletingLastPathComponent().path
    }
    
    @objc func openSettings(with reply: @escaping (Bool, Error?) -> Void) {
        print("XPC Service: Opening Settings...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            
            let mainAppBundleID = "com.haroldgao.EditorJumper-X"
            
            process.launchPath = "/usr/bin/open"
            process.arguments = ["-b", mainAppBundleID, "--args", "--show-settings"]
                
            do {
                try process.run()
                print("XPC Service: Successfully opened settings via open command")
                reply(true, nil)
            } catch {
                print("XPC Service: Failed to open settings: \(error.localizedDescription)")
                reply(false, error)
            }
        }
    }
}
