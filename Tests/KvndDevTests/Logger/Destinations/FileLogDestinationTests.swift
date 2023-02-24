import XCTest
@testable import KvndDev

final class FileLogDestinationTests: XCTestCase {
    // MARK: Tests

    func test_destination_successfully_instantiate_when_file_could_be_created() throws {
        let fileManager = MockFileManager { stubs in
            stubs.createFileAtPath = { _, _ in MockFileHandle() }
        }
        XCTAssertNoThrow(try FileLogDestination(using: fileManager, fileName: "", atPath: ""))
    }

    func test_destination_throws_error_when_containing_directory_couldnt_be_created() {
        let fileManager = MockFileManager { stubs in
            stubs.createDirectoryAtPath = { _ in
                throw NSError(domain: "", code: -1)
            }
        }
        let destination = try? FileLogDestination(using: fileManager, fileName: "", atPath: "")
        XCTAssertNil(destination)
    }

    func test_destination_throws_error_when_file_couldnt_be_created() {
        let fileManager = MockFileManager { stubs in
            stubs.createFileAtPath = { _, _ in
                throw NSError(domain: "", code: -1)
            }
        }
        let destination = try? FileLogDestination(using: fileManager, fileName: "", atPath: "")
        XCTAssertNil(destination)
    }

    func test_destination_outputs_correct_data_to_file() throws {
        var data = Data()

        let fileHandle = MockFileHandle { stubs in
            stubs.writeData = { data.append(contentsOf: $0) }
        }
        let fileManager = MockFileManager { stubs in
            stubs.createFileAtPath = { _, _ in fileHandle }
        }

        let subject = try FileLogDestination(using: fileManager, fileName: "", atPath: "")

        let thread = "thread"
        let message = "message"
        let metadata = LogMetadata(
            level: .info,
            thread: thread,
            date: Date(timeIntervalSince1970: 0),
            message: message)

        Task {
            await subject.output(metadata)
        }

        XCTAssertEventuallyEqual(data, Data("\(metadata.defaultStringValue)\n".utf8))
    }
}
