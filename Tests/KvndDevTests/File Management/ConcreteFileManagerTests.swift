import XCTest
@testable import KvndDev

final class ConcreteFileManagerTests: XCTestCase {
    // MARK: Mocks
    
    private final class MockFileManager: FileManager {
        var fileExists = false
        var isDirectory = false
        var contentsOfDirectory = [URL]()
        
        var createdAtPath: String?
        var attributes: [FileAttributeKey: Any]?
        var contents: Data?

        override func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
            isDirectory?.pointee = ObjCBool(self.isDirectory)
            return fileExists
        }
        
        override func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
            self.createdAtPath = path
            self.attributes = attributes
        }
        
        override func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
            self.createdAtPath = path
            self.contents = data
            self.attributes = attr
            return true
        }
        
        override func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions = []) throws -> [URL] {
            return contentsOfDirectory
        }
    }
    
    private struct MockAttributesProvider: FileManagerAttributesProvider {
        func attributesForCreatingDirectory(atPath path: String) -> [FileAttributeKey: Any]? {
            return [.creationDate: Date(timeIntervalSince1970: 0)]
        }
        
        func attributesForCreatingFile(atPath path: String) -> [FileAttributeKey: Any]? {
            return [.creationDate: Date(timeIntervalSince1970: 0)]
        }
    }
    
    // MARK: Tests

    func test_createDirectory_throws_if_path_already_exists_and_is_file() {
        let manager = MockFileManager()
        manager.fileExists = true
        manager.isDirectory = false
        let subject = ConcreteFileManager(fileManager: manager)
        do {
            try subject.createDirectory(atPath: "")
            XCTFail("The creation shouldn't be successful")
        } catch {
            XCTAssert(error is ConcreteFileManager.CreateDirectoryError)
        }
    }
    
    func test_createDirectory_passes_correct_attributes() {
        let manager = MockFileManager()
        manager.fileExists = false
        manager.isDirectory = false

        let subject = ConcreteFileManager(fileManager: manager, attributesProvider: MockAttributesProvider())
        XCTAssertNoThrow(try subject.createDirectory(atPath: ""))
        
        XCTAssertEqual(manager.createdAtPath, "")
        XCTAssertEqual(manager.attributes?.count, 1)
        XCTAssertEqual(manager.attributes?[.creationDate] as? Date, Date(timeIntervalSince1970: 0))
    }
    
    func test_createDirectory_skips_if_path_already_exists() {
        let manager = MockFileManager()
        manager.fileExists = true
        manager.isDirectory = true
        let subject = ConcreteFileManager(fileManager: manager)
        XCTAssertNoThrow(try subject.createDirectory(atPath: ""))
        XCTAssertNil(manager.createdAtPath)
    }
    
    func test_createFile_throws_if_path_already_exists_and_is_directory() {
        let manager = MockFileManager()
        manager.fileExists = true
        manager.isDirectory = true
        let subject = ConcreteFileManager(fileManager: manager)
        do {
            _ = try subject.createFile(atPath: "", contentIfEmpty: nil)
            XCTFail("The creation shouldn't be successful")
        } catch {
            XCTAssert(error is ConcreteFileManager.CreateFileError)
        }
    }
    
    func test_createFile_passes_correct_data_and_attributes_when_creating_file() throws {
        let manager = MockFileManager()
        manager.fileExists = false
        let data = Data("Hello".utf8)
        let subject = ConcreteFileManager(fileManager: manager, attributesProvider: MockAttributesProvider())
        _ = try? subject.createFile(atPath: "", contentIfEmpty: data)
        XCTAssertEqual(manager.contents, data)
        XCTAssertEqual(manager.attributes?.count, 1)
        XCTAssertEqual(manager.attributes?[.creationDate] as? Date, Date(timeIntervalSince1970: 0))
    }
    
    func test_createFile_returns_writtable_file_handle() throws {
        let manager = MockFileManager()
        manager.fileExists = true
        manager.isDirectory = false

        let path = try XCTUnwrap(Bundle.module.path(forResource: "README", ofType: nil))
        let subject = ConcreteFileManager(fileManager: manager)
        XCTAssertNoThrow(try subject.createFile(atPath: path, contentIfEmpty: nil))
    }
    
    func test_contents_of_directory_returns_correct_urls() throws {
        let manager = MockFileManager()
        manager.contentsOfDirectory = [
            URL(string: "/"),
            URL(string: "/"),
            URL(string: "/"),
        ].compactMap { $0 }
        let subject = ConcreteFileManager(fileManager: manager)

        XCTAssertEqual(try subject.contentsOfDirectory(atPath: "").count, 3)
        XCTAssertEqual(try subject.contentsOfDirectory(atPath: ""), [
            URL(string: "/"),
            URL(string: "/"),
            URL(string: "/"),
        ])
    }
}
