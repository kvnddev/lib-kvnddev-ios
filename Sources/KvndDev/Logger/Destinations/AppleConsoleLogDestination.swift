import Foundation

public struct AppleConsoleLogDestination: LogDestination {
    // MARK: Properties

    public let identifier: NSObjectProtocol = NSString(string: "KvndDev Console")

    private let printFunction: (String) -> ()
    private let logInProduction: Bool
    private let isProduction: Bool

    // MARK: Initialization

    init(printFunction: @escaping (String) -> (),
         logInProduction: Bool = true,
         isProduction: Bool = true) {
        self.printFunction = printFunction
        self.logInProduction = logInProduction
        self.isProduction = isProduction
    }

    public init(logInProduction: Bool = true, isProduction: Bool = true) {
        self.printFunction = { print($0) }
        self.logInProduction = logInProduction
        self.isProduction = isProduction
    }

    // MARK: LogDestination

    public func output(_ metadata: LogMetadata) async {
        if logInProduction || !isProduction {
            printFunction(metadata.defaultStringValue)
        }
    }
}
