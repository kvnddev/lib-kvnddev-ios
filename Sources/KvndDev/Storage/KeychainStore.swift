import Foundation

public final class KeychainStore: Storage {
    private struct EmptyValue: Codable, StorableData {
        init() { }
        init(storableData: Data) throws { }
        var storableData: Data? { Data() }
    }

    struct Functions {
        var add: ((CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus) = SecItemAdd
        var copyMatching: ((CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus) = SecItemCopyMatching
        var delete: ((CFDictionary) -> OSStatus) = SecItemDelete
    }

    // MARK: Properties

    private let accessGroup: String?
    private let synchronizable: Bool
    private let nonPersistentInstallationStorage: Storage
    private var functions = Functions()

    // MARK: Standard Instance

    public static let standard = KeychainStore()

    // MARK: Initialization

    init(accessGroup: String? = nil,
         synchronizable: Bool = true,
         nonPersistentInstallationStorage: Storage = UserDefaultsStore.standard) {
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
        self.nonPersistentInstallationStorage = nonPersistentInstallationStorage
    }

    // MARK: Utils

    private func nonPersistentKey(forKey key: String) -> String {
        "keychain_has_\(key)"
    }

    private func defaultQuery(forKey key: String) -> [CFString: Any] {
        var query = [CFString: Any]()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecUseDataProtectionKeychain] = kCFBooleanTrue
        query[kSecAttrAccount] = key
        query[kSecAttrSynchronizable] = (synchronizable ? kCFBooleanTrue : kCFBooleanFalse)
        query[kSecAttrAccessGroup] = accessGroup
        return query
    }

    // MARK: Storage

    public func value<Value: StorableData>(forKey key: String) throws -> Value {
        if !nonPersistentInstallationStorage.hasValue(forKey: nonPersistentKey(forKey: key)) {
            set(Value.empty, forKey: key)
            throw StorageError.noData
        }

        var query = defaultQuery(forKey: key)
        query[kSecReturnData] = kCFBooleanTrue

        var item: CFTypeRef?
        let status = functions.copyMatching(query as CFDictionary, &item)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw StorageError.readError
        }
        guard let item = item as? Data else {
            throw StorageError.invalidData
        }
        return try Value(storableData: item)
    }

    public func set<Value: StorableData>(_ value: Value?, forKey key: String) {
        remove(atKey: key)

        if let value = value {
            var query = defaultQuery(forKey: key)
            query[kSecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            query[kSecValueData] = value.storableData
            let status = functions.add(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Error storing \(key) in Keychain: \(status)")
            } else {
                nonPersistentInstallationStorage.set(EmptyValue(), forKey: nonPersistentKey(forKey: key))
            }
        } else {
            let status = remove(atKey: key)
            if status != errSecSuccess {
                print("Error deleting \(key) in Keychain: \(status)")
            }
        }
    }

    public func hasValue(forKey key: String) -> Bool {
        guard nonPersistentInstallationStorage.hasValue(forKey: nonPersistentKey(forKey: key)) else {
            return false
        }

        let query = defaultQuery(forKey: key)
        let status = functions.copyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    @discardableResult
    private func remove(atKey key: String) -> OSStatus {
        let query = defaultQuery(forKey: key)
        let status = functions.delete(query as CFDictionary)
        nonPersistentInstallationStorage.set(EmptyValue.empty, forKey: nonPersistentKey(forKey: key))
        return status
    }
}

#if canImport(XCTest)
// swiftlint:disable:next no_grouping_extension
extension KeychainStore {
    func test_setFunctions(_ functions: Functions) {
        self.functions = functions
    }
}
#endif
