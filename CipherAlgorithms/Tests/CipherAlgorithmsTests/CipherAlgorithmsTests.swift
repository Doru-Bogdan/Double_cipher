import XCTest
@testable import CipherAlgorithms

final class CipherAlgorithmsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CipherAlgorithms().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
