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

		let expectation = self.expectation(description: "test not nill")
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

		let expectation = self.expectation(description: "returns empty test")
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
	
	func test_loadData_Returns_from_Api_5_teams() {
		
		let updatedMock = MockRequestsManager()
		for _ in 1...5 {
			updatedMock.teamsReturn.append(Team())
		}
		sut.requestsManager = updatedMock
		
		let expectation = self.expectation(description: "returns 5teams test")
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
		XCTAssertEqual(outputTeams?.count, 5)
	}
	
	func test_loadData_Returns_from_Data_5_teams() {
		
		let updatedUserDefaults = MockUserDefaults()
		updatedUserDefaults.shouldTeamReturnFromApi = false
		updatedUserDefaults.shouldEventReturnFromApi = false
		updatedUserDefaults.shouldPlayerReturnFromApi = false
		
		let updatedRequestsManager = MockRequestsManager()
		
		let updatedMockDataManager = MockDataManager()
		for _ in 1...5 {
			updatedMockDataManager.teamsReturn.append(Team())
			updatedRequestsManager.teamsReturn.append(Team())
			updatedRequestsManager.eventsReturn.append(Event())
			updatedRequestsManager.playersReturn.append(Player())
		}
		sut.dataManager = updatedMockDataManager
		
		let expectation = self.expectation(description: "returns 5teams from data test")
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
		XCTAssertEqual(outputTeams?.count, 5)
	}
	
}
