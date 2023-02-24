import XCTest
@testable import KvndDev

final class AppleConsoleLogDestinationTests: XCTestCase {
    // MARK: Tests

    func test_destination_filters_logs_when_log_in_production_is_disable_and_its_production() {
        let shouldntLog = expectation(description: "The output shouldn't have been logged")
        shouldntLog.isInverted = true

        let subject = AppleConsoleLogDestination(printFunction: { _ in
            shouldntLog.fulfill()
        }, logInProduction: false, isProduction: true)

        Task {
            await subject.output(LogMetadata(level: .error, message: "Hello"))
        }

        waitForExpectations(timeout: 1)
    }

    func test_destination_doesnt_filter_logs_when_log_in_production_is_enabled_and_its_production() {
        let shouldLog = expectation(description: "The output should have been logged")

        let subject = AppleConsoleLogDestination(printFunction: { _ in
            shouldLog.fulfill()
        }, logInProduction: true, isProduction: true)

        Task {
            await subject.output(LogMetadata(level: .error, message: "Hello"))
        }

        waitForExpectations(timeout: 1)
    }
}
