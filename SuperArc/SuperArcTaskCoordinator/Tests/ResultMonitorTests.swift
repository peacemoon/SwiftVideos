//
//  Copyright © 2019 An Tran. All rights reserved.
//

@testable import SuperArcTaskCoordinator
import PromiseKit
import XCTest

class ResultMonitorTests: XCTestCase {

    class Resource {

        var value: Int

        init(initialValue: Int) {
            self.value = initialValue
        }

        func changeValue(to newValue: Int, continuation: @escaping ResultMonitor<Void>.Continuation) {
            self.value = newValue
            continuation(Result.success(()))
        }
    }

    func testContinuation() {
        let expectation1 = self.expectation(description: #function)
        let expectation2 = self.expectation(description: #function)

        let monitor = ResultMonitor<Void>()
        let resource = Resource(initialValue: 1)

        let continuation1: ResultMonitor<Void>.Continuation = { result in
            switch result {
                case .success:
                    XCTAssertEqual(resource.value, 2)
                case .failure(let error):
                    XCTFail("wrong state \(error)")
            }

            expectation1.fulfill()
        }

        let continuation2: ResultMonitor<Void>.Continuation = { result in
            switch result {
                case .success:
                    XCTAssertEqual(resource.value, 2)
                case .failure(let error):
                    XCTFail("wrong state \(error)")
            }

            expectation2.fulfill()
        }

        monitor.run(continuation1) { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                resource.changeValue(to: 2, continuation: continuation)
            }
        }

        monitor.run(continuation2) { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                resource.changeValue(to: 3, continuation: continuation)
            }
        }

        wait(for: [expectation1, expectation2], timeout: 5.0)
    }
}
