import XCTest
@testable import BasketBallApp

class LoadingManagerTests: XCTestCase {

	var sut: LoadingManager!
	
    override func setUp() {

		sut = LoadingManager(requestsManager: MockRequestsManager(), dataManager: MockCoreDataManager(), defaultsManager: MockUserDefaults())
    }

    override func tearDown() {
		sut = nil
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
	
}
