import Files
import Foundation
import XCTest

@testable import WillowCore

class LexerTests: XCTestCase {

    func testZeroDiff() throws {
        let input =
          """
          {:fib n:Int -> Int
              {? n < 2
                  -> n
               ?
                  -> {fib n:n - 1} + {fib n:n - 2}
              }
          }
          """

        let lexer = Lexer()
        do {
            let tokens = try lexer.tokenize(input)
            let output = tokens.map({ $0.value }).reduce("") {$0 + $1}
            XCTAssert(input == output, "Input and output from the Lexer differ\n\nINPUT:\n\n\(input)\n\nOUTPUT\n\n\(output)")
        } catch {
            XCTAssert(false, "Unexpected error \(error)")
        }
    }
}
