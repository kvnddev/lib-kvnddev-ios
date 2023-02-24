import XCTest
@testable import KvndDev

final class StructDeinitTests: XCTestCase {
    // MARK: Mocks

    private struct Mock {
        private let deinitializer: StructDeinit

        init(counter: Counter) {
            deinitializer = StructDeinit {
                counter.count += 1
            }
        }
    }

    private class Counter {
        var count = 0
    }

    // MARK: Tests

    func test_StructDeinit_should_call_onDeinit_when_deinitialized() {
        let deinitCalled = expectation(description: "onDeinit should get called")
        _ = StructDeinit {
            deinitCalled.fulfill()
        }
        waitForExpectations(timeout: 0)
    }

    func test_StructDeinit_works_in_symbiose_with_structs() {
        let counter = Counter()

        var mock1: Mock? = Mock(counter: counter)
        var mock2: Mock? = mock1
        var mock3: Mock? = mock2

        mock1 = nil
        XCTAssertEqual(counter.count, 0)
        mock2 = nil
        XCTAssertEqual(counter.count, 0)
        mock3 = Mock(counter: Counter())
        _ = mock3
        XCTAssertEqual(counter.count, 1)
    }
}
