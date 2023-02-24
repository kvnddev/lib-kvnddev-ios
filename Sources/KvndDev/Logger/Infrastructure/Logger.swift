import Foundation

public final class Logger {
    // MARK: Properties

    private let serialQueue = DispatchQueue(label: "dev.kvnd.logger")
    private let semaphore = DispatchSemaphore(value: 0)

    private var destinations: [LogDestination]

    // MARK: Initialization

    public init(destinations: [LogDestination] = []) {
        self.destinations = destinations
    }

    public convenience init(destination: LogDestination) {
        self.init(destinations: [destination])
    }

    // MARK: Destinations Mutation

    public func addDestination(_ destination: LogDestination) {
        destinations.append(destination)
    }

    public func removeDestination(_ destination: LogDestination) {
        destinations.removeAll { $0.identifier === destination.identifier }
    }

    // MARK: Logging

    public func log(_ level: LogMetadata.Level,
                    message: @autoclosure () -> String,
                    file: StaticString = #file,
                    function: StaticString = #function,
                    line: UInt = #line) {
        let metadata = LogMetadata(level: level, date: Date(), message: message(), file: file, function: function, line: line)
        log(metadata)
    }

    public func log(_ metadata: LogMetadata) {
        log(metadata, in: destinations)
    }

    private func log(_ metadata: LogMetadata, in destinations: [LogDestination]) {
        serialQueue.async {
            Task {
                for dest in destinations where metadata.level.value >= dest.outputLevel.value {
                    await dest.output(metadata)
                }
                self.semaphore.signal()
            }
            self.semaphore.wait()
        }
    }
}
