import XCTest

func XCTAssertEventuallyEqual<T>(
    _ expression1: @autoclosure () -> T,
    _ expression2: @autoclosure () -> T,
    _ message: @autoclosure () -> String = "",
    pollingTime: TimeInterval = 0.1,
    timeout: TimeInterval = 3,
    file: StaticString = #filePath,
    line: UInt = #line) where T: Equatable {
        let timeoutDate = Date(timeIntervalSinceNow: timeout)
        while timeoutDate.timeIntervalSinceNow >= 0 {
            if expression1() == expression2() {
                return
            }
            RunLoop.main.run(until: Date(timeIntervalSinceNow: pollingTime))
        }
        XCTFail(message(), file: file, line: line)
}

func XCTAssertRemainsEqual<T>(
    _ expression1: @autoclosure () -> T,
    _ expression2: @autoclosure () -> T,
    _ message: @autoclosure () -> String = "",
    for time: TimeInterval = 1,
    file: StaticString = #filePath,
    line: UInt = #line) where T: Equatable {
        XCTAssertEqual(expression1(), expression2(), file: file, line: line)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: time))
        XCTAssertEqual(expression1(), expression2(), file: file, line: line)
}

