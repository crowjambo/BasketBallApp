import XCTest
import OHHTTPStubs
@testable import BasketBallApp

class LoadingManagerTests: XCTestCase {
	
	var sut: LoadingManager!
	
    override func setUp() {
		sut = LoadingManager(requestsManager: MockRequestsManager(), dataManager: MockDataManager(), defaultsManager: MockUserDefaults())
    }

    override func tearDown() {
		sut = nil
		HTTPStubs.removeAllStubs()
    }
	
	func test_loadData_ReturnsNotNil() {

		let expectation = self.expectation(description: "test")
		var outputTeams: [Team]?
		sut.loadData { (res) in
			switch res {
			case .success(let teams):
				outputTeams = teams
			case .failure(let err):
				debugPrint(err)
			}
			expectation.fulfill()
		}

		waitForExpectations(timeout: 1, handler: nil)
		XCTAssertNotNil(outputTeams)
	}

	func test_loadData_ReturnsEmpty() {

		let expectation = self.expectation(description: "returns failure test")
		var outputTeams: [Team]?
		sut.loadData { (res) in
			switch res {
			case .success(let teams):
				outputTeams = teams
			case .failure:
				break
			}
			expectation.fulfill()
		}

		waitForExpectations(timeout: 1, handler: nil)
		XCTAssertEqual(outputTeams?.count, 0)
	}
	
	
}
