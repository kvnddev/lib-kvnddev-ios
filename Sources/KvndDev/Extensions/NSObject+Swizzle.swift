import Foundation

extension NSObject {
    @discardableResult
    static func swizzleInstanceMethod(_ originalSelector: Selector, with newSelector: Selector) -> Bool {
        guard let originalMethod = class_getInstanceMethod(self, originalSelector),
              let newMethod = class_getInstanceMethod(self, newSelector) else {
            return false
        }
        method_exchangeImplementations(originalMethod, newMethod)
        return true
    }
}
