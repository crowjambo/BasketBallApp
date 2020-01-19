import XCTest
@testable import BasketBallApp

class BasketBallAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	// MARK: - Alamofire tests
	
	func test_get_request_loadTeams_Alamofire_names_match(){
		var teamsCol: [Team]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getTeams { (teams, error) in
			teamsCol = teams
			
			expectation.fulfill()
		}
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertEqual(teamsCol?.first?.teamName, "Atlanta Hawks")
	}
	
	func test_get_request_loadPlayers_Alamofire_not_null(){
		var playerCol: [Player]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getPlayers(teamName: "Atlanta Hawks") { (players, error) in
			playerCol = players
			
			expectation.fulfill()
		}
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(playerCol)
	}
	
	func test_get_request_loadMatches_Alamofire_not_null(){
		var matchesCollection: [MatchHistory]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getEvents(teamID: "134881") { (matches, error) in
			matchesCollection = matches
			
			expectation.fulfill()
		}
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(matchesCollection)
	}
	
	func test_get_request_loadTeams_Alamofire_not_null(){
		var teamsCollection: [Team]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getTeams { (teams, error) in
			teamsCollection = teams
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(teamsCollection)
	}
	
	// MARK: - URLSession tests
	
	func test_get_Request_loadTeams_matchingName(){
		var teamsCollection:[Team]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getTeams(completionHandler: { (teams) in
			teamsCollection = teams

			expectation.fulfill()
		})
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertEqual(teamsCollection?.first?.teamName, "Atlanta Hawks")
	}

	func test_getRequest_loadPlayers_not_null(){
		var playerCol:[Player]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getPlayers(teamName: "Atlanta", completionHandler: {(players) in
			playerCol = players
			
			expectation.fulfill()
		})
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil([playerCol])
	}
	
	func test_getRequest_loadMatches_not_null(){
		var matchCollection:[MatchHistory]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getMatches(teamID: "134881", completionHandler: { (matches) in
			matchCollection = matches
			
			expectation.fulfill()
			
		})
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(matchCollection)
	}
	
	func test_getRequest_loadTeams_not_null(){
		
		var teamsCollection:[Team]?
		let expectation = self.expectation(description: "loading")
		
		NetworkClient.getTeams(completionHandler: { (teams) in
			teamsCollection = teams

			expectation.fulfill()
		})
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(teamsCollection)
	}
	

}
