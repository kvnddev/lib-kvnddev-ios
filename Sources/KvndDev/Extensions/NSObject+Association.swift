import Foundation

public extension NSObject {
    enum Policy {
        case strong
        case weak

        fileprivate var objcEquivalent: objc_AssociationPolicy {
            switch self {
            case .strong:
                return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            case .weak:
                return .OBJC_ASSOCIATION_ASSIGN
            }
        }
    }

    func associate<T: AnyObject>(_ value: T?, forKey key: UnsafeRawPointer, policy: Policy = .strong) {
        objc_setAssociatedObject(self, key, value, policy.objcEquivalent)
    }
    
    func associatedValue<T: AnyObject>(forKey key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(self, key) as? T
    }

    func associatedValue<T: AnyObject>(forKey key: UnsafeRawPointer, defaultValue: @autoclosure () -> T, policy: Policy = .strong) -> T {
        if let existingValue: T = associatedValue(forKey: key) {
            return existingValue
        }

        let value = defaultValue()
        associate(value, forKey: key, policy: policy)
        return value
    }
}
