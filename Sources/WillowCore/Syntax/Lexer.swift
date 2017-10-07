import Foundation

public class Lexer {

    public enum LexerError: Error {
        case invalidToken(token: String, line: Int, column: Int)
    }

    public func tokenize(_ source: String) throws -> [Token] {
        var remaining = source
        var tokens = [Token]()
        var lineNumber = 1
        var columnNumber = 1
        
        while !remaining.isEmpty {
            var line = remaining
            if let newlineIndex = remaining.index(of: "\n") {
                let range = remaining.startIndex...newlineIndex
                line = String(line[range])

                lineNumber += 1
                columnNumber = 1
            }

            remaining.removeSubrange(remaining.startIndex..<remaining.index(remaining.startIndex, offsetBy: line.count))

            while !line.isEmpty {
                guard let (result, consumed) = consume(line) else { throw LexerError.invalidToken(token: line, line: lineNumber, column: columnNumber) }
                tokens.append(result)

                line.removeSubrange(line.startIndex..<line.index(line.startIndex, offsetBy: consumed))
                columnNumber += consumed
            }
        }

        return combineWhitespace(tokens)
    }

    private func consume(_ line: String) -> (result: Token, consumed: Int)? {
        for kind in Token.Kind.all {
            let pattern = kind.pattern
            var longestMatch: String?
            var length = line.count
            var range = line.startIndex..<line.index(line.startIndex, offsetBy: length)
            while longestMatch == nil {
                let segment = String(line[range])
                if segment.range(of: pattern, options: .regularExpression) == range {
                    longestMatch = segment
                    break
                }

                length -= 1
                if length < 0 { break }

                range = line.startIndex..<line.index(line.startIndex, offsetBy: length)
            }

            if let longestMatch = longestMatch {
                return (Token(kind: kind, value: longestMatch), length)
            }
        }

        return nil
    }

    private func combineWhitespace(_ tokens: [Token]) -> [Token] {
        return tokens.reduce([]) { (reduced: [Token], next: Token) -> [Token] in
            var reduced = reduced
            if let last = reduced.last, last.kind == .whitespace {
                _ = reduced.popLast()
                let combined = Token(kind: .whitespace, value: last.value + next.value)
                reduced.append(combined)
            } else {
                reduced.append(next)
            }
            return reduced
        }
    }
}
