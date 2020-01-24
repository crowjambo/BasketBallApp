import XCTest
@testable import BasketBallApp

class AlamofireTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
	
	// TODO: API calls should be Mocked to be tested properly
	// TODO: Use dependency injection to test singletons
	
	func test_get_request_loadTeams_Alamofire_names_match() {
		var teamsCol: [Team]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getTeams { (teams, _) in
			teamsCol = teams
			
			expectation.fulfill()
		}
		waitForExpectations(timeout: 21, handler: nil)
		XCTAssertEqual(teamsCol?.first?.teamName, "Atlanta Hawks")
	}
	
	func test_get_request_loadPlayers_Alamofire_not_null() {
		var playerCol: [Player]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getPlayers(teamName: "Atlanta Hawks") { (players, _) in
			playerCol = players
			
			expectation.fulfill()
		}
		waitForExpectations(timeout: 2, handler: nil)
		XCTAssertNotNil(playerCol)
	}
	
	func test_get_request_loadMatches_Alamofire_not_null() {
		var matchesCollection: [Event]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getEvents(teamID: "134881") { (matches, _) in
			matchesCollection = matches
			
			expectation.fulfill()
		}
		waitForExpectations(timeout: 2, handler: nil)
		XCTAssertNotNil(matchesCollection)
	}
	
	func test_get_request_loadTeams_Alamofire_not_null() {
		var teamsCollection: [Team]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getTeams { (teams, _) in
			teamsCollection = teams
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		XCTAssertNotNil(teamsCollection)
	}

}
