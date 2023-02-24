import Foundation

public protocol FileManagerAttributesProvider {
    func attributesForCreatingDirectory(atPath path: String) -> [FileAttributeKey: Any]?
    func attributesForCreatingFile(atPath path: String) -> [FileAttributeKey: Any]?
}

public struct ConcreteFileManager: FileManagerType {
    public enum CreateDirectoryError: Error {
        case fileExistsAndIsntDirectory
    }

    public enum CreateFileError: Error {
        case fileExistsAndIsDirectory
        case couldntCreateFileHandle
    }

    // MARK: Properties

    private let fileManager: FileManager
    private let attributesProvider: FileManagerAttributesProvider?

    // MARK: Initialization

    public init(fileManager: FileManager = .default, attributesProvider: FileManagerAttributesProvider? = nil) {
        self.fileManager = fileManager
        self.attributesProvider = attributesProvider
    }

    // MARK: FileManagerType

    public func createDirectory(atPath path: String) throws {
        var isDirectory = ObjCBool(false)
        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                return
            }
            // The file exists but isn't a directory... We'll throw an error.
            throw CreateDirectoryError.fileExistsAndIsntDirectory
        }

        let attributes = attributesProvider?.attributesForCreatingDirectory(atPath: path)
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: attributes)
    }

    public func createFile(atPath path: String, contentIfEmpty content: Data?) throws -> FileHandleType {
        var isDirectory = ObjCBool(false)
        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                // The file exists but is a directory... We'll throw an error.
                throw CreateFileError.fileExistsAndIsDirectory
            }
        } else {
            let attributes = attributesProvider?.attributesForCreatingDirectory(atPath: path)
            fileManager.createFile(atPath: path, contents: content, attributes: attributes)
        }

        guard let fileHandle = FileHandle(forUpdatingAtPath: path) else {
            throw CreateFileError.couldntCreateFileHandle
        }
        return ConcreteFileHandle(fileHandle: fileHandle)
    }

    public func contentsOfDirectory(atPath path: String) throws -> [URL] {
        let url: URL
        if #available(iOS 16.0, *) {
            url = URL(filePath: path)
        } else {
            url = URL(fileURLWithPath: path)
        }

        return try fileManager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [
                .creationDateKey,
                .fileSizeKey,
            ],
            options: .skipsSubdirectoryDescendants)
    }

    public func removeFile(atPath path: String) throws {
        try fileManager.removeItem(atPath: path)
    }
}
