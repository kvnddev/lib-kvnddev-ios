import Foundation

public extension Collection {
    var orNilIfEmpty: Self? {
        return isEmpty ? nil : self
    }
}
