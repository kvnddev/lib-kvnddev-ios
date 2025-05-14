import Foundation

public protocol Storage {
    func value<Value: StorableData>(forKey key: String) throws -> Value
    func set<Value: StorableData>(_ value: Value?, forKey key: String)
    func hasValue(forKey key: String) -> Bool
}

public enum StorageError: Error {
    case readError
    case invalidData
    case noData
}
