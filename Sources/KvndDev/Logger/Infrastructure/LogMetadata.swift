import Foundation

public struct LogMetadata {
    public enum Level: CaseIterable {
        case verbose
        case info
        case warning
        case error

        var value: Int {
            Self.allCases.firstIndex(of: self)!
        }

        public static var emojisPerLevel: [Level: String] = [
            .verbose: "🐛",
            .info: "ℹ️",
            .warning: "⚠️",
            .error: "❌",
        ]

        fileprivate var stringOutput: String {
            [Self.emojisPerLevel[self], String(describing: self)]
                .compactMap { $0 }
                .joined(separator: " ")
        }
    }

    // MARK: Properties

    private static var defaultDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    public var level: Level
    public var thread: String
    public var date: Date
    public var message: String
    public var file: String
    public var function: StaticString
    public var line: UInt

    // MARK: Initialization

    public init(level: Level, message: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        self.init(level: level, date: Date(), message: message, file: file, function: function, line: line)
    }

    init(level: Level,
         thread: String = String(cString: __dispatch_queue_get_label(nil)),
         date: Date,
         message: String,
         file: StaticString = #file,
         function: StaticString = #function,
         line: UInt = #line) {
        self.level = level
        self.thread = thread
        self.date = date
        self.message = message
        self.file = (file.description as NSString).lastPathComponent
        self.function = function
        self.line = line
    }

    // MARK: Default String Value

    public var defaultStringValue: String {
        "\(Self.defaultDateFormatter.string(from: date)) - \(thread) - \(file):L\(line):\(function)\t\(level.stringOutput): \(message)"
    }
}
