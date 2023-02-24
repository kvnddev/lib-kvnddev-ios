import XCTest
@testable import KvndDev

final class RollingFileLogDestinationTests: XCTestCase {
    // MARK: Tests

    func test_initializing_destination_throws_if_creating_directory_fails() {
        let fileManager = MockFileManager {
            $0.createDirectoryAtPath = { _ in
                throw NSError(domain: "", code: -1)
            }
        }

        do {
            _ = try RollingFileLogDestination(using: fileManager, atPath: "")
            XCTFail("Creating the directory failed, we should have thrown an error")
        } catch {}
    }
    
    func test_initializing_destination_throws_if_creating_log_file_fails() {
        let fileManager = MockFileManager {
            $0.createFileAtPath = { _, _ in
                throw NSError(domain: "", code: -1)
            }
        }

        do {
            _ = try RollingFileLogDestination(using: fileManager, atPath: "")
            XCTFail("Creating the directory failed, we should have thrown an error")
        } catch {}
    }
    
    func test_initializing_destination_names_log_files_correctly() {
        var path = ""
        let fileManager = MockFileManager {
            $0.createFileAtPath = { creationPath, _ in
                path = creationPath
                return MockFileHandle()
            }
            $0.contentsOfDirectoryAtPath = { _ in [] }
        }

        XCTAssertNoThrow(try RollingFileLogDestination(using: fileManager, atPath: ""))
        XCTAssertTrue(path.hasPrefix("session-"))
        XCTAssertTrue(path.hasSuffix(".log"))
    }
}
