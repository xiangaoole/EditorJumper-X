//
//  ContentView.swift
//  EditorJumper-X
//
//  Created by user on 2025/5/23.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    func callXPCService() {
        // Connect to the XPC service
        print("📁 Getting current file path from Xcode...")

        // 连接到 XPC Service
        let connection = NSXPCConnection(serviceName: "com.haroldgao.EditorJumper-X.EditorJumperForXcodeXPCService")
        connection.remoteObjectInterface = NSXPCInterface(with: EditorJumperForXcodeXPCServiceProtocol.self)
        connection.resume()

        let service = connection.remoteObjectProxy as? EditorJumperForXcodeXPCServiceProtocol
        let isSandboxed = ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
        print("Is sandboxed: \(isSandboxed)")

        service?.jumpToCursor(line: 10, column: 1) { success, error, log in
            print("XPC Service: Jump to cursor \(success ? "succeeded" : "failed")")
            if let log = log {
                print("XPC Service: Log: \(log)")
            }
            if let error = error {
                print("XPC Service: Error: \(error)")
            }
        }
    }

//    func test() {
//        let filePath = "/Users/user/Public/myGithub/ios/EditorJumper-X/EditorJumperForXcodeXPCService/EditorJumperForXcodeXPCService.swift"
//        let line = 11
//        let column = 6
//        let task = Process()
//        task.launchPath = "/usr/local/bin/cursor"
//        task.arguments = [
//            "-g", "\(filePath):\(line):\(column)",
//        ]
//
//        try? task.run()
//        task.waitUntilExit()
//    }
}

struct ContentView: View {
    @StateObject var viewModel = MainViewModel()
    var body: some View {
        VStack {
            Button {
                print("Button pressed")
                viewModel.callXPCService()
            } label: {
                Text("Jump to Cursor")
                    .padding()
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
