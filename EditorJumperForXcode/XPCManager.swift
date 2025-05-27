//
//  XPCManager.swift
//  EditorJumperForXcode
//
//  Created by user on 2025/5/27.
//

import Foundation

final class XPCManager {
    static let shared = XPCManager()

    private var connection: NSXPCConnection?

    private init() {
        setupConnection()
    }

    private func setupConnection() {
        let conn = NSXPCConnection(serviceName: "com.haroldgao.EditorJumper-X.EditorJumperForXcodeXPCService")
        conn.remoteObjectInterface = NSXPCInterface(with: EditorJumperForXcodeXPCServiceProtocol.self)

        conn.invalidationHandler = {
            print("⚠️ XPC Connection invalidated.")
            self.connection = nil
        }

        conn.interruptionHandler = {
            print("⚠️ XPC Connection interrupted.")
        }

        conn.resume()
        self.connection = conn
    }

    func getService() -> EditorJumperForXcodeXPCServiceProtocol? {
        if connection == nil {
            setupConnection()
        }
        return connection?.remoteObjectProxy as? EditorJumperForXcodeXPCServiceProtocol
    }

    func invalidate() {
        connection?.invalidate()
        connection = nil
    }
}
