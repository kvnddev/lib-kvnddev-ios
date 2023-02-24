import XCTest
@testable import KvndDev

final class NSObjectSwizzleTests: XCTestCase {
    // MARK: Mocks

    private final class Mock: NSObject {
        var func1Expectation: XCTestExpectation?
        var func2Expectation: XCTestExpectation?

        @objc func function1() {
            func1Expectation?.fulfill()
        }
        
        @objc func function2() {
            func2Expectation?.fulfill()
        }
    }
    
    // MARK: Tests

    func test_swizzling_exchange_methods_implementations() {
        Mock.swizzleInstanceMethod(
            #selector(Mock.function1),
            with: #selector(Mock.function2)
        )

        let object = Mock()
        object.func2Expectation = expectation(description: "function2 should get called")
        object.perform(#selector(Mock.function1))
        waitForExpectations(timeout: 0)
        
        object.func1Expectation = expectation(description: "function1 should get called")
        object.perform(#selector(Mock.function2))
        waitForExpectations(timeout: 0)
    }
}
