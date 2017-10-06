import Foundation

struct Args {
    private(set) var help = false
    private(set) var version = false

    private(set) var inputFile: String!

    private(set) var valid = false

    init(arguments: [String]) {
        var args: [String] = arguments.reversed()
        _ = args.popLast()  // Dump the program name
        while !args.isEmpty {
            let arg = args.popLast()!

            switch arg {
            case "-h", "--help":
                help = true
            case "-v", "--version":
                version = true
            default:
                if inputFile == nil {
                    inputFile = arg
                }
            }
        }

        valid = inputFile != nil
    }
}

