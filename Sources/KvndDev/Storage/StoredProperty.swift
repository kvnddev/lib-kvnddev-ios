import Foundation

@propertyWrapper
public final class StoredProperty<Value: StorableData, Store: Storage> {
    // MARK: Properties

    private let store: Store
    private let storageKey: String

    public var wrappedValue: Value? {
        didSet {
            store.set(wrappedValue, forKey: storageKey)
        }
    }

    // MARK: Initialization

    public init(store: Store, storageKey: String, defaultValue: @autoclosure (() -> Value?) = nil) {
        self.store = store
        self.storageKey = storageKey
        self.wrappedValue = try? store.value(forKey: storageKey)

        if wrappedValue == nil {
            wrappedValue = defaultValue()
            store.set(wrappedValue, forKey: storageKey)
        }
    }
}
