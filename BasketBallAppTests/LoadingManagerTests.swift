import XCTest
@testable import BasketBallApp

class LoadingManagerTests: XCTestCase {
	
	var sut: LoadingManager!
	
	var mockDefManager: MockUserDefaults!
	var mockReqManager: MockRequestsManager!
	var mockDataManager: MockDataManager!
	
    override func setUp() {
		
		mockDataManager = MockDataManager()
		mockReqManager = MockRequestsManager()
		mockDefManager = MockUserDefaults(teamReturn: true, playerReturn: true, eventReturn: true)
		
		sut = LoadingManager(requestsManager: mockReqManager, dataManager: mockDataManager, defaultsManager: mockDefManager)
    }

    override func tearDown() {
		sut = nil
		mockDataManager = nil
		mockReqManager = nil
		mockDataManager = nil
    }
	
	func test_loadData_ReturnsNotNil_SomeTeamsLoaded() {

		mockReqManager.teamsReturn.append(Team())
		
		let expectation = self.expectation(description: "test not nill")
		var outputTeams: [Team]?
		sut.loadData { (res) in
			switch res {
			case .success(let teams):
				outputTeams = teams
			case .failure(_):
				break
			}
			expectation.fulfill()
		}

		waitForExpectations(timeout: 1, handler: nil)
		XCTAssertNotNil(outputTeams)
	}

	func test_loadData_isEmpty_ReturnsNil() {

		let emptyReqManager = MockRequestsManager()
		sut.requestsManager = emptyReqManager
		
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
		XCTAssertNil(outputTeams)
	}
	
	func test_loadData_Returns_from_Api_5_teams() {
		
		for _ in 1...5 {
			mockReqManager.teamsReturn.append(Team())
		}
		
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
		
		mockDefManager.shouldTeamReturnFromApi = false
		mockDefManager.shouldPlayerReturnFromApi = false
		mockDefManager.shouldEventReturnFromApi = false
		
		for _ in 1...5 {
			mockDataManager.teamsReturn.append(Team())
		}
		
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
	
	func test_loadData_Returns_TeamsFromData_PlayersFromApi_10each() {
		
		mockDefManager.shouldTeamReturnFromApi = false
		mockDefManager.shouldPlayerReturnFromApi = true
		mockDefManager.shouldEventReturnFromApi = true
		
		for _ in 1...10 {
			mockDataManager.teamsReturn.append(Team())
			mockReqManager.teamsReturn.append(Team())
		}
		
		let expectation = self.expectation(description: "returns 10teams from data/api test")
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
		XCTAssertEqual(outputTeams?.count, 10)
	}
	
}
