import XCTest
@testable import BasketBallApp

class BasketBallAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	
	func test_get_Request_loadTeams_matchingName(){
		var teamsCollection:[TeamInfo]?
		let expectation = self.expectation(description: "loading")
		
		NetworkAccess.getTeams(completionHandler: { (teams) in
			teamsCollection = teams

			expectation.fulfill()
		})
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertEqual(teamsCollection?.first?.teamName, "Atlanta Hawks")
	}

	func test_getRequest_loadPlayers_not_null(){
		var playerCol:[Player]?
		let expectation = self.expectation(description: "loading")
		
		NetworkAccess.getPlayers(teamName: "Atlanta", completionHandler: {(players) in
			playerCol = players
			
			expectation.fulfill()
		})
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil([playerCol])
	}
	
	func test_getRequest_loadMatches_not_null(){
		var matchCollection:[MatchHistory]?
		let expectation = self.expectation(description: "loading")
		
		NetworkAccess.getMatches(teamID: "134881", completionHandler: { (matches) in
			matchCollection = matches
			
			expectation.fulfill()
			
		})
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(matchCollection)
	}
	
	func test_getRequest_loadTeams_not_null(){
		
		var teamsCollection:[TeamInfo]?
		let expectation = self.expectation(description: "loading")
		
		NetworkAccess.getTeams(completionHandler: { (teams) in
			teamsCollection = teams

			expectation.fulfill()
		})
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(teamsCollection)
	}
	

	


}
