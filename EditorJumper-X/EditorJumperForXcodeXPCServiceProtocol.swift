//
//  EditorJumperForXcodeXPCServiceProtocol.swift
//  EditorJumperForXcode
//
//  Created by user on 2025/5/25.
//

import Foundation

/// The protocol that this service will vend as its API. This protocol will also need to be visible to the process hosting the service.
@objc protocol EditorJumperForXcodeXPCServiceProtocol {
    /// Get the current file path from Xcode using AppleScript
    func getCurrentFilePath(with reply: @escaping (String?, Error?) -> Void)

    /// Combined operation: get current file path and open in Cursor
    func openInCursor(line: Int, column: Int, with reply: @escaping (Bool, Error?, String?) -> Void)
    
    /// Open settings window of the main app
    func openSettings(with reply: @escaping (Bool, Error?) -> Void)
}
