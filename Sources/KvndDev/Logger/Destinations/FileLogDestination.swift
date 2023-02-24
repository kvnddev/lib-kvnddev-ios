import Foundation

public struct FileLogDestination: LogDestination {
    // MARK: Properties

    public let identifier: NSObjectProtocol

    private let fileManager: FileManagerType
    private let fileName: String
    private let path: String
    private let fileHandle: FileHandleType

    // MARK: Initialization

    public init(using fileManager: FileManagerType = ConcreteFileManager(), fileName: String, atPath path: String) throws {
        self.identifier = NSString(format: "KvndDev File: %@/%@", path, fileName)

        self.fileManager = fileManager
        self.fileName = fileName.appending(".log")
        self.path = path

        try fileManager.createDirectory(atPath: path)
        fileHandle = try fileManager.createFile(atPath: (path as NSString).appendingPathComponent(self.fileName), contentIfEmpty: nil)
    }

    // MARK: LogDestination

    public func output(_ metadata: LogMetadata) async {
        let data = Data("\(metadata.defaultStringValue)\n".utf8)
        try? fileHandle.write(data: data)
    }
}
