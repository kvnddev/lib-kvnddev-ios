import XCTest
@testable import KvndDev

final class ConcreteFileHandleTests: XCTestCase {
    // MARK: Tests

    func test_file_handle_is_closed_when_deinit() throws {
        let path = try XCTUnwrap(Bundle.module.path(forResource: "README", ofType: nil))
        let fileHandle = try XCTUnwrap(FileHandle(forReadingAtPath: path))
        var subject: ConcreteFileHandle? = ConcreteFileHandle(fileHandle: fileHandle)

        XCTAssertNoThrow(try fileHandle.synchronize())

        _ = subject
        subject = nil
        
        do {
            try fileHandle.synchronize()
            XCTFail("The file handle should have been closed and synchronize fail")
        } catch {}
    }
}
