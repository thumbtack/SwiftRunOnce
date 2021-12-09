import Foundation
import XCTest

class RunOnceTest: XCTestCase {
    func testOnlyRunsOnce() {
        var innerCounter = 0
        var outerCounter = 0

        let runner = {
            RunOnce.forLifetime(of: self) {
                innerCounter += 1
            }

            outerCounter += 1
        }

        for _ in 0 ..< 10 {
            runner()
        }

        XCTAssertEqual(1, innerCounter)
        XCTAssertEqual(10, outerCounter)
    }

    func testReentrancySafe() {
        var innerCounter = 0
        var middleCounter = 0
        var outerCounter = 0

        let runner = {
            RunOnce.forLifetime(of: self) {
                middleCounter += 1
                RunOnce.forLifetime(of: self) {
                    innerCounter += 1
                }
            }

            outerCounter += 1
        }

        for _ in 0 ..< 10 {
            runner()
        }

        XCTAssertEqual(1, innerCounter)
        XCTAssertEqual(1, middleCounter)
        XCTAssertEqual(10, outerCounter)
    }

    func testObjectExtension() {
        var innerCounter = 0
        var outerCounter = 0

        let runner = {
            self.runOnce {
                innerCounter += 1
            }

            outerCounter += 1
        }

        for _ in 0 ..< 10 {
            runner()
        }

        XCTAssertEqual(1, innerCounter)
        XCTAssertEqual(10, outerCounter)
    }
}
