//
//  EditorJumperForXcodeXPCServiceProtocol.swift
//  EditorJumperForXcodeXPCService
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

/*
 To use the service from an application or other process, use NSXPCConnection to establish a connection to the service by doing something like this:

     connectionToService = NSXPCConnection(serviceName: "com.haroldgao.EditorJumper-X.EditorJumperForXcodeXPCService")
     connectionToService.remoteObjectInterface = NSXPCInterface(with: (any EditorJumperForXcodeXPCServiceProtocol).self)
     connectionToService.resume()

 Once you have a connection to the service, you can use it like this:

     if let proxy = connectionToService.remoteObjectProxy as? EditorJumperForXcodeXPCServiceProtocol {
         proxy.openInCursor(line: 10, column: 5) { success, filePath, error in
             if success {
                 NSLog("Successfully opened file: \(filePath ?? "unknown") in Cursor")
             } else {
                 NSLog("Failed to open in Cursor: \(error?.localizedDescription ?? "unknown error")")
             }
         }
     }

 And, when you are finished with the service, clean up the connection like this:

     connectionToService.invalidate()
 */
