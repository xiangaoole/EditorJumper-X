//
//  MainViewModel.swift
//  EditorJumper-X
//
//  Created by user on 2025/5/26.
//

import Foundation
import AppKit

class MainViewModel: ObservableObject {
    @Published var showingSettings = false
    
    // Show error dialog
    private func showErrorDialog(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }

    func openInCursor() {
        let connection = NSXPCConnection(serviceName: "com.haroldgao.EditorJumper-X.EditorJumperForXcodeXPCService")
        connection.remoteObjectInterface = NSXPCInterface(with: EditorJumperForXcodeXPCServiceProtocol.self)
        connection.resume()

        let service = connection.remoteObjectProxy as? EditorJumperForXcodeXPCServiceProtocol
        let isSandboxed = ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
        print("Is sandboxed: \(isSandboxed)")

        service?.openInCursor(line: 1, column: 1) { success, error, log in
            print("Jump to cursor \(success ? "succeeded" : "failed")")
            if let log = log {
                print("Log: \(log)")
            }
            if let error = error {
                print("Error: \(error)")
                self.showErrorDialog(title: "Operation Failed", message: error.localizedDescription)
            }
        }
    }
}
