import Foundation

public protocol FileManagerType {
    func createDirectory(atPath path: String) throws
    func createFile(atPath path: String, contentIfEmpty content: Data?) throws -> FileHandleType
    func contentsOfDirectory(atPath path: String) throws -> [URL]
    func removeFile(atPath path: String) throws
}

public protocol FileHandleType {
    func write(data: Data) throws
}
