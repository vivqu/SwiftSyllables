import UIKit
import XCTest
@testable import SwiftSyllables

class SwiftSyllablesTest : XCTestCase {

    func testSingleLetter() {
        let vowels = ["a", "e", "i", "o", "u"]
        for vowel in vowels {
            let syllables : Int = SwiftSyllables.getSyllables(vowel)
            XCTAssertEqual(syllables, 1)
        }

        let consonants = ["x", "y", "z", "b", "g"]
        for letter in consonants {
            let syllables : Int = SwiftSyllables.getSyllables(letter)
            XCTAssertEqual(syllables, 1)
        }

        // Special case for w (pronounced "double-you")
        XCTAssertEqual(SwiftSyllables.getSyllables("w"), 3)
    }

    func testInvalidWords() {
        // Empty string
        XCTAssertEqual(SwiftSyllables.getSyllables(""), 0)

        // Whitespaces
        XCTAssertEqual(SwiftSyllables.getSyllables("     "), 0)

        // Invalid characters
        XCTAssertEqual(SwiftSyllables.getSyllables("!@%,,,"), 0)
    }

    func DISABLED_testNumbers() {
        // Numbers
        XCTAssertEqual(SwiftSyllables.getSyllables("1"), 0)
        XCTAssertEqual(SwiftSyllables.getSyllables("123"), 0)
    }

    func testRealWords() {
        XCTAssertEqual(SwiftSyllables.getSyllables("Testing"), 2)
    }

    func testNonRealWords() {
        XCTAssertEqual(SwiftSyllables.getSyllables("lalala"), 3)
    }
}
