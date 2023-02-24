import Foundation

public final class StructDeinit {
    // MARK: Properties

    private let onDeinit: () -> Void

    // MARK: Initialization

    init(onDeinit: @escaping () -> Void) {
        self.onDeinit = onDeinit
    }

    deinit {
        onDeinit()
    }
}
