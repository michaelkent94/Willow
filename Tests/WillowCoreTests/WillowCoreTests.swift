import Files
import Foundation
import XCTest

@testable import WillowCore

class WillowCoreTests: XCTestCase {

    func testFileZeroDiff() throws {
        // Create a temporary folder as a sandbox
        let fileSystem = FileSystem()
        let tempFolder = fileSystem.temporaryFolder
        let testFolder = try tempFolder.createSubfolderIfNeeded(withName: "WillowCoreTests")
        print(testFolder)

        // Make sure we get a clean state with an empty folder
        try testFolder.empty()

        // `cd` to the temporary folder
        FileManager.default.changeCurrentDirectoryPath(testFolder.path)

        // Make a new source file
        let inputFileName = "testFileZeroDiff.ww"
        try fileSystem.createFile(at: inputFileName)

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
        try File(path: inputFileName, using: FileManager.default).write(string: input)

        let willow = WillowCore(arguments: ["willow", inputFileName])
        try willow.run()

        let outputFileName = "testFileZeroDiff.willowout"
        let outputFile = try File(path: outputFileName, using: FileManager.default)
        let output = try outputFile.readAsString()

        XCTAssert(output == input, "Input differs from output")
    }
}
