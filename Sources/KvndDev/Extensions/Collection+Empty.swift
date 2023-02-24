import Foundation

extension Collection {
    var orNilIfEmpty: Self? {
        return isEmpty ? nil : self
    }
}
