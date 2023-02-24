import Foundation

public struct ConcreteFileHandle: FileHandleType {
    // MARK: Properties

    private let fileHandle: FileHandle
    private let deinitializer: StructDeinit

    // MARK: Initialization

    public init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
        self.deinitializer = StructDeinit { [fileHandle] in
            try? fileHandle.close()
        }
    }

    // MARK: FileHandleType

    public func write(data: Data) throws {
        if #available(iOS 13.4, *) {
            try fileHandle.write(contentsOf: data)
        } else {
            fileHandle.write(data)
        }
    }
}
