import XCTest
@testable import SwiftSyllables

final class SwiftSyllablesTests: XCTestCase {
    
    // These are examples where SwiftSyllables returns the correct value
    private let testDataPassing = [
        "Milk": 1,
        "Swift": 1,
        "Hello": 2,
        "Monkey": 2,
        "Elephant": 3,
        "Lullaby": 3,
        "Community": 4,
        "Conditioning": 4
    ]
    
    // These are examples where SwiftSyllables returns the incorrect value
    private let testDataFailures = [
        "Goodbye": 2,
        "Turtle": 2,
    ]
    
    func testSwiftSyllables() {
        
        testDataPassing.forEach {
            let expected = $0.value
            let actual = SwiftSyllables.getSyllables($0.key)
            XCTAssertEqual(expected, actual, "Testing \($0.key)")
        }
        
        testDataFailures.forEach {
            let expected = $0.value
            let actual = SwiftSyllables.getSyllables($0.key)
            XCTAssertNotEqual(expected, actual, "Testing \($0.key)")
        }
    }
}
