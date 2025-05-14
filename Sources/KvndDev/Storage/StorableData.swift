import Foundation

public protocol StorableData {
    init(storableData: Data) throws
    var storableData: Data? { get }
}

extension StorableData {
    static var empty: Self? { nil }
}
