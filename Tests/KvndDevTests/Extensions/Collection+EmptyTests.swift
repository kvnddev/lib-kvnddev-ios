import XCTest
@testable import KvndDev

final class CollectionEmptyTests: XCTestCase {
    // MARK: Tests

    func test_orNilIfEmpty_returns_self_when_not_empty() {
        let str = "hello"
        XCTAssertEqual(str.orNilIfEmpty, str)
    }
    
    func test_orNilIfEmpty_returns_nil_when_empty() {
        let str = ""
        XCTAssertNil(str.orNilIfEmpty)
    }
}
