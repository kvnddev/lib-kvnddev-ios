import Foundation
import KvndDev

final class MockFileManager: FileManagerType {
    // MARK: Stubs

    struct Stubs {
        var createDirectoryAtPath: ((String) throws -> Void)?
        var createFileAtPath: ((String, Data?) throws -> FileHandleType)?
        var contentsOfDirectoryAtPath: ((String) throws -> [URL])?
        var removeFileAtPath: ((String) throws -> Void)?
    }
    
    // MARK: Properties

    var stubs = Stubs()
    
    // MARK: Initialization
    
    init(setup: ((inout Stubs) -> Void)? = nil) {
        setup?(&stubs)
    }
    
    // MARK: FileManagerType

    func createDirectory(atPath path: String) throws {
        try stubs.createDirectoryAtPath?(path)
    }

    func createFile(atPath path: String, contentIfEmpty content: Data?) throws -> FileHandleType {
        try stubs.createFileAtPath!(path, content)
    }

    func contentsOfDirectory(atPath path: String) throws -> [URL] {
        try stubs.contentsOfDirectoryAtPath!(path)
    }

    func removeFile(atPath path: String) throws {
        try stubs.removeFileAtPath?(path)
    }
}
