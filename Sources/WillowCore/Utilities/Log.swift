import Foundation

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        write(data)
    }
}

struct Log {
    private static var stderr = FileHandle.standardError

    static func error(_ thing: CustomStringConvertible) {
        print(thing, to: &stderr)
    }

    static func error(_ thing: Error) {
        print(thing, to: &stderr)
    }

    static func debug(_ thing: CustomStringConvertible) {
        #if DEBUG
        print("*** Debug: \(thing)")
        #endif
    }

    static func write(_ thing: CustomStringConvertible) {
        print(thing)
    }
}
