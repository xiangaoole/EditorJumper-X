//
//  SourceEditorCommand.swift
//  EditorJumperForXcode
//
//  Created by user on 2025/5/25.
//

import AppKit
import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        print("🚀 Extension called!")
        print("📋 Command identifier: \(invocation.commandIdentifier)")
        
        if invocation.commandIdentifier.hasSuffix(".OpenSettings") {
            openSettings(completionHandler: completionHandler)
        } else {
            openInCursor(with: invocation, completionHandler: completionHandler)
        }
    }
    
    private func openInCursor(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        // Get current selection (cursor position)
        let selections = invocation.buffer.selections
        var lineNumber = 0
        var columnNumber = 0
        
        if let selection = selections.firstObject as? XCSourceTextRange {
            lineNumber = selection.start.line + 1 // Convert to 1-based
            columnNumber = selection.start.column + 1 // Convert to 1-based
        }
        
        print("📍 Line: \(lineNumber), Column: \(columnNumber)")
        
        // Connect to XPC Service
        let connection = NSXPCConnection(serviceName: "com.haroldgao.EditorJumper-X.EditorJumperForXcodeXPCService")
        connection.remoteObjectInterface = NSXPCInterface(with: EditorJumperForXcodeXPCServiceProtocol.self)
        connection.resume()
        
        let service = connection.remoteObjectProxy as? EditorJumperForXcodeXPCServiceProtocol
        
        service?.openInCursor(line: lineNumber, column: columnNumber) { _, error, log in
            DispatchQueue.main.async {
                connection.invalidate()
                
                if let error = error {
                    let alert = NSAlert()
                    alert.messageText = "Jump Failed"
                    alert.informativeText = "❌ Failed to jump to Cursor: \(error.localizedDescription)\n\(log ?? "")"
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                } else {
                    print("✅ Successfully jumped to Cursor at line \(lineNumber), column \(columnNumber)")
                }
                
                completionHandler(error)
            }
        }
    }
    
    private func openSettings(completionHandler: @escaping (Error?) -> Void) {
        print("🔧 Opening Settings...")
        
        // Use Process to launch main app with arguments
        let process = Process()
        
        // Get main app path
        let mainAppBundleID = "com.haroldgao.EditorJumper-X"
        
        // Try to find app path by Bundle ID
        if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: mainAppBundleID) {
            let appPath = appURL.appendingPathComponent("Contents/MacOS/EditorJumper-X").path
            
            process.launchPath = appPath
            process.arguments = ["--show-settings"]
            
            do {
                try process.run()
                print("✅ Successfully launched settings")
                completionHandler(nil)
            } catch {
                print("❌ Failed to launch settings: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = "Settings Failed"
                    alert.informativeText = "❌ Failed to open settings: \(error.localizedDescription)"
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                    completionHandler(error)
                }
            }
        } else {
            // If app not found, try using open command
            process.launchPath = "/usr/bin/open"
            process.arguments = ["-b", mainAppBundleID, "--args", "--show-settings"]
            
            do {
                try process.run()
                print("✅ Successfully opened settings via open command")
                completionHandler(nil)
            } catch {
                print("❌ Failed to open settings: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = "Settings Failed"
                    alert.informativeText = "❌ Failed to open settings: \(error.localizedDescription)"
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                    completionHandler(error)
                }
            }
        }
    }
}
