import Foundation

public struct Token: CustomStringConvertible {

    public enum Kind: Int {
        case whitespace
        case op

        case floatLiteral
        case integerLiteral
        case booleanLiteral
        case stringLiteral

        case leftBrace
        case rightBrace
        case leftBracket
        case rightBracket
        case leftParen
        case rightParen

        case singleQuote
        case doubleQuote
        case dot
        case comma
        case colon
        case semicolon
        case questionMark
        case at
        case hash

        case id

        case _count

        static var all: [Kind] {
            return (0..<Kind._count.rawValue).map({ Kind(rawValue: $0)! })
        }

        var pattern: String {
            switch self {
            case .whitespace:
                let newline = "(\r|\n|\r\n)"
                let comment = "//[^\(newline)]*\(newline)"
                return "( |\t|\(newline)|\(comment))+"
            case .op:
                return "[/\\-\\+!\\*%<>&\\|\\^~\\.=]+"

            case .floatLiteral:
                let decimal = "[0-9_]+"
                let decimalFraction = "\\.(\(decimal))"
                let decimalExponent = "(e|E)(\\+|\\-)?(\(decimal))"
                let floatExtras = "(((\(decimalFraction))(\(decimalExponent)))|((\(decimalFraction))|(\(decimalExponent))))"
                return "(\(decimal))(\(floatExtras))"
            case .integerLiteral:
                let decimal = "[0-9_]+"
                let hexadecimal = "0x[0-9a-fA-F_]+"
                return "\\-?((\(hexadecimal))|(\(decimal)))"
            case .booleanLiteral:
                return "(true|false)"
            case .stringLiteral:
                return "\"[^\"]*\"" // TODO: Handle escape sequences

            case .leftBrace: return "\\{"
            case .rightBrace: return "\\}"
            case .leftBracket: return "\\["
            case .rightBracket: return "\\]"
            case .leftParen: return "\\("
            case .rightParen: return "\\)"

            case .singleQuote: return "\'"
            case .doubleQuote: return "\""
            case .dot: return "\\."
            case .comma: return ","
            case .colon: return ":"
            case .semicolon: return ";"
            case .questionMark: return "\\?"
            case .at: return "@"
            case .hash: return "#"

            case .id: return "[a-zA-Z]+"

            case ._count: return ""
            }
        }
    }

    public let kind: Kind
    public let value: String

    public var description: String {
        return "<\(kind), \"\(value)\">"
    }
}
