import Foundation

// 这是一个测试文件，用于测试 EditorJumper-X 扩展
// Test file for EditorJumper-X extension

class TestClass {
    
    func testFunction() {
        print("Hello from line 8!")
        
        // 将光标放在这一行，然后测试扩展
        let testVariable = "This is line 11"
        
        for i in 1...5 {
            print("Loop iteration \(i) - line \(13 + i)")
        }
        
        // 测试不同的行和列位置
        let anotherTest = "Line 19"
        
        if true {
            print("Conditional block - line 22")
        }
    }
    
    func anotherFunction() {
        // 这是第二个函数 - line 27
        let data = [1, 2, 3, 4, 5]
        
        data.forEach { number in
            print("Number: \(number)")
        }
    }
}

// 文件结束 