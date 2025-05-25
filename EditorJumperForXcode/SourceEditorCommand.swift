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
        
        jumpToCursor(with: invocation, completionHandler: completionHandler)
    }
    
    private func jumpToCursor(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
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
        
        service?.jumpToCursor(line: lineNumber, column: columnNumber) { _, error, _ in
            DispatchQueue.main.async {
                connection.invalidate()
                
                if let error = error {
                    print("❌ Failed to jump to Cursor: \(error)")
                    
                    let alert = NSAlert()
                    alert.messageText = "Jump Failed"
                    alert.informativeText = "Failed to jump to Cursor: \(error.localizedDescription)"
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
}
