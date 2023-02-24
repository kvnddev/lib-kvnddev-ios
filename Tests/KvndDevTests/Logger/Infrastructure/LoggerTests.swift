import XCTest
@testable import KvndDev

final class LoggerTests: XCTestCase {
    // MARK: Mocks

    private final class Mock: LogDestination {
        let identifier: NSObjectProtocol
        let outputLevel: LogMetadata.Level
        private(set) var outputs = [LogMetadata]()

        init(identifier: String, outputLevel: LogMetadata.Level) {
            self.identifier = identifier as NSString
            self.outputLevel = outputLevel
        }

        func output(_ metadata: LogMetadata) async {
            outputs.append(metadata)
        }
    }

    // MARK: Tests

    func test_logging_higher_level_than_destination_logs_to_destination() {
        let destination = Mock(identifier: "test", outputLevel: .warning)
        let subject = Logger(destination: destination)
        subject.log(.error, message: "Hello")
        XCTAssertEventuallyEqual(destination.outputs.first?.message, "Hello")
    }

    func test_logging_lower_level_than_destination_doesnt_log_to_destination() {
        let destination = Mock(identifier: "test", outputLevel: .warning)
        let subject = Logger(destination: destination)
        subject.log(.verbose, message: "Hello 1")
        subject.log(.error, message: "Hello 2")
        XCTAssertEventuallyEqual(destination.outputs.first?.message, "Hello 2")
    }

    func test_adding_destination_logs_new_logs_to_it() {
        let subject = Logger(destinations: [])
        let destination = Mock(identifier: "test", outputLevel: .warning)
        subject.addDestination(destination)
        subject.log(.error, message: "Hello")
        XCTAssertEventuallyEqual(destination.outputs.first?.message, "Hello")
    }

    func test_removing_destination_stops_logging_to_it() {
        let destination = Mock(identifier: "test", outputLevel: .warning)
        let subject = Logger(destinations: [destination])
        subject.removeDestination(destination)
        subject.log(.error, message: "Hello")
        XCTAssertRemainsEqual(destination.outputs.count, 0)
    }
}
