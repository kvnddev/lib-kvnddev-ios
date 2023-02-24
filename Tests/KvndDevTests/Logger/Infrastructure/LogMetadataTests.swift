import XCTest
@testable import KvndDev

final class LogMetadataTests: XCTestCase {
    // MARK: Tests

    func test_default_string_value_returns_correctly_formatter_string() {
        let thread = "thread"
        let message = "message"
        let line = #line + 1
        let subject = LogMetadata(
            level: .info,
            thread: thread,
            date: Date(timeIntervalSince1970: 0),
            message: message)

        let date = "1970-01-01 00:00:00.000"
        let testName = #function
        XCTAssertEqual(subject.defaultStringValue, "\(date) - \(thread) - LogMetadataTests.swift:L\(line):\(testName)\tℹ️ info: \(message)")
    }
}
