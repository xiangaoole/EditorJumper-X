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
        // 获取当前选择（光标位置）
        let selections = invocation.buffer.selections
        var lineNumber = 0
        var columnNumber = 0
        
        if let selection = selections.firstObject as? XCSourceTextRange {
            lineNumber = selection.start.line + 1 // 转换为1-based
            columnNumber = selection.start.column + 1 // 转换为1-based
        }
        
        print("📍 Line: \(lineNumber), Column: \(columnNumber)")
        
        // 连接到 XPC Service
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
        
        // 使用 Process 启动主应用并传递参数
        let process = Process()
        
        // 获取主应用的路径
        let mainAppBundleID = "com.haroldgao.EditorJumper-X"
        
        // 尝试通过 Bundle ID 找到应用路径
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
            // 如果找不到应用，尝试使用 open 命令
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
