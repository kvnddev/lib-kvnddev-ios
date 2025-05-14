import Foundation

public final class UserDefaultsStore: Storage {
    // MARK: Properties

    private let backingUserDefaults: UserDefaults

    // MARK: Standard Instance

    public static let standard = UserDefaultsStore()

    // MARK: Initialization

    init(backingUserDefaults: UserDefaults = .standard) {
        self.backingUserDefaults = backingUserDefaults
    }

    // MARK: Storage

    public func value<Value: StorableData>(forKey key: String) throws -> Value {
        guard let data = backingUserDefaults.data(forKey: key) else {
            throw StorageError.noData
        }
        return try Value(storableData: data)
    }

    public func set<Value: StorableData>(_ value: Value?, forKey key: String) {
        if let value {
            backingUserDefaults.set(value.storableData, forKey: key)
        } else {
            backingUserDefaults.removeObject(forKey: key)
        }
    }

    public func hasValue(forKey key: String) -> Bool {
        backingUserDefaults.object(forKey: key) != nil
    }
}
