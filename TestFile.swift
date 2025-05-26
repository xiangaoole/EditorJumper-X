import Foundation

// This is a test file for testing the EditorJumper-X extension
// Test file for EditorJumper-X extension

class TestClass {
    
    func testFunction() {
        print("Hello from line 8!")
        
        // Place cursor on this line, then test the extension
        let testVariable = "This is line 11"
        
        for i in 1...5 {
            print("Loop iteration \(i) - line \(13 + i)")
        }
        
        // Test different line and column positions
        let anotherTest = "Line 19"
        
        if true {
            print("Conditional block - line 22")
        }
    }
    
    func anotherFunction() {
        // This is the second function - line 27
        let data = [1, 2, 3, 4, 5]
        
        data.forEach { number in
            print("Number: \(number)")
        }
    }
}

// End of file 