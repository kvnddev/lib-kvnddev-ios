import Foundation
import KvndDev

final class MockFileHandle: FileHandleType {
    // MARK: Stubs

    struct Stubs {
        var writeData: ((Data) -> Void)?
    }
    
    // MARK: Properties

    var stubs = Stubs()
    
    // MARK: Initialization
    
    init(setup: ((inout Stubs) -> Void)? = nil) {
        setup?(&stubs)
    }
    
    // MARK: FileHandleType

    func write(data: Data) throws {
        stubs.writeData?(data)
    }
}
