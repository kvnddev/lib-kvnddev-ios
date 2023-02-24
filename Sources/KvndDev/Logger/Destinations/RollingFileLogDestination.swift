import Foundation

public final class RollingFileLogDestination: LogDestination {
    public enum FileNameFormat {
        case date(format: String)

        var newFileName: String {
            switch self {
            case .date(let format):
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = format
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.calendar = Calendar(identifier: .gregorian)
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                return dateFormatter.string(from: Date())
            }
        }
    }

    public enum RollingStrategy {
        case maximumNumberOfDays(Int)
        case maximumDirectorySize(UInt)
    }

    // MARK: Properties

    public let identifier: NSObjectProtocol

    private let fileManager: FileManagerType
    private let path: String
    private let fileNameFormat: FileNameFormat
    private let rollingStrategy: RollingStrategy

    private let currentDestination: FileLogDestination
    private var cleanUpTimer: Timer?

    // MARK: Initialization

    public init(using fileManager: FileManagerType = ConcreteFileManager(),
                atPath path: String,
                fileNameFormat: FileNameFormat = .date(format: "'session-'yyyy'-'MM'-'dd'-'HH':'mm':'ss'"),
                rollingStrategy: RollingStrategy = .maximumNumberOfDays(30),
                cleanUpInterval: TimeInterval = 10) throws {
        self.identifier = NSString(format: "KvndDev Rolling File %@", path)

        self.fileManager = fileManager
        self.path = path
        self.fileNameFormat = fileNameFormat
        self.rollingStrategy = rollingStrategy

        self.currentDestination = try FileLogDestination(using: fileManager, fileName: fileNameFormat.newFileName, atPath: path)

        cleanUpIfNecessary()
        cleanUpTimer = Timer(timeInterval: cleanUpInterval, repeats: true) { [weak self] _ in
            self?.cleanUpIfNecessary()
        }
        RunLoop.main.add(cleanUpTimer!, forMode: .common)
    }

    deinit {
        cleanUpTimer?.invalidate()
    }

    // MARK: Clean up

    private func cleanUpIfNecessary() {
        do {
            let fileUrls = try fileManager.contentsOfDirectory(atPath: path)
            let resources = try fileUrls.map { try $0.resourceValues(forKeys: [.creationDateKey, .fileSizeKey]) }
            let creationDates = resources.compactMap { $0.creationDate }
            let fileSizes = resources.compactMap { $0.fileSize }

            guard fileUrls.count == creationDates.count, creationDates.count == fileSizes.count else {
                print("There was an error")
                return
            }

            var filesSortedByDate = zip(zip(fileUrls, creationDates), fileSizes)
                .map { ($0.0, $0.1, $1) }
                .sorted { $0.1 < $1.1 }

            switch rollingStrategy {
            case .maximumDirectorySize(let maximumSize):
                var currentSize = filesSortedByDate.reduce(0) { $0 + $1.2 }
                while currentSize > maximumSize && !filesSortedByDate.isEmpty {
                    let fileToRemove = filesSortedByDate.removeFirst()
                    try fileManager.removeFile(atPath: fileToRemove.0.path)
                    currentSize -= fileToRemove.2
                }

            case .maximumNumberOfDays(let maximumNumberOfDays):
                let calendar = Calendar(identifier: .gregorian)
                for file in filesSortedByDate {
                    guard let numberOfDaysSinceCreation = calendar.dateComponents([.day], from: file.1, to: Date()).day else {
                        return
                    }

                    guard numberOfDaysSinceCreation > maximumNumberOfDays else {
                        return
                    }
                    try fileManager.removeFile(atPath: file.0.path)
                }
            }
        } catch {}
    }

    // MARK: LogDestination

    public func output(_ metadata: LogMetadata) async {
        await currentDestination.output(metadata)
    }
}
