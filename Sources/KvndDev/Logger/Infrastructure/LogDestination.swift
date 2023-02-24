import Foundation

public protocol LogDestination {
    var identifier: NSObjectProtocol { get }
    var outputLevel: LogMetadata.Level { get }

    func output(_ metadata: LogMetadata) async
}

public extension LogDestination {
    var outputLevel: LogMetadata.Level {
        .warning
    }
}
