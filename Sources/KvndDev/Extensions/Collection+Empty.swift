import Foundation

public extension Collection {
    var orNilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}
