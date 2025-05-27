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
        
        var isCompletionCalled = false

        func complete(_ error: Error?) {
            if isCompletionCalled { return }
            isCompletionCalled = true
            print("✅ Calling completionHandler")
            completionHandler(error)
        }
        
        let fallbackTimer = DispatchSource.makeTimerSource()
        fallbackTimer.schedule(deadline: .now() + 4.5)
        fallbackTimer.setEventHandler {
            print("⚠️ Timeout fallback called")
            complete(nil)
        }
        fallbackTimer.resume()
        
        if invocation.commandIdentifier.hasSuffix(".OpenSettings") {
            openSettings { error in
                fallbackTimer.cancel()
                complete(error)
            }
        } else {
            openInCursor(with: invocation) { error in
                fallbackTimer.cancel()
                complete(error)
            }
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
        
        guard let service = XPCManager.shared.getService() else {
            completionHandler(NSError(domain: "XPCServiceUnavailable", code: -1, userInfo: nil))
            return
        }
        
        service.openInCursor(line: lineNumber, column: columnNumber) { _, error, log in
            DispatchQueue.main.async {
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
        
        guard let service = XPCManager.shared.getService() else {
            completionHandler(NSError(domain: "XPCServiceUnavailable", code: -1, userInfo: nil))
            return
        }
        
        service.openSettings { success, error in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = NSAlert()
                    alert.messageText = "Settings Failed"
                    alert.informativeText = "❌ Failed to open settings: \(error.localizedDescription)"
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                } else if success {
                    print("✅ Successfully opened settings")
                } else {
                    let alert = NSAlert()
                    alert.messageText = "Settings Failed"
                    alert.informativeText = "❌ Failed to open settings: Unknown error"
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
                
                completionHandler(error)
            }
        }
    }
}
