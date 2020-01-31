import XCTest
import Foundation
import Alamofire
import OHHTTPStubs

@testable import BasketBallApp

class HttpRequestsManagerTests: XCTestCase {
	
	var sut: ExternalDataRetrievable!
	
    override func setUp() {
		sut = SportsApiService()
    }

    override func tearDown() {
		sut = nil
		HTTPStubs.removeAllStubs()
    }
	
	func test_getTeams_correctParsing() {
		
		let expectation = self.expectation(description: "teams expectation")
		var outputTeams: [Team]?
		
		stub(condition: isHost("thesportsdb.com")) { (_) -> HTTPStubsResponse in
			return HTTPStubsResponse(fileAtPath: OHPathForFile("teams2.json", type(of: self))!, statusCode: 200, headers: ["Content-Type": "application/json"])
		}
		
		sut.getTeams { (res) in
			switch res {
			case .success(let teams):
				outputTeams = teams
				expectation.fulfill()
			case .failure(_):
				break
			}
		}
		waitForExpectations(timeout: 1, handler: nil)
		XCTAssertEqual(outputTeams?[0].teamName!, "NoodleSoup Team")
	}
	
	func test_getPlayers_correctParsing() {
		
		let expectation = self.expectation(description: "players expectation")
		var outputPlayers: [Player]?
		
		stub(condition: isHost("thesportsdb.com")) { (_) -> HTTPStubsResponse in
			return HTTPStubsResponse(fileAtPath: OHPathForFile("players.json", type(of: self))!, statusCode: 200, headers: ["Content-Type": "application/json"])
		}
		
		sut.getPlayers(teamName: "Atlanta Hawks") { (res) in
			switch res {
			case .success(let players):
				outputPlayers = players
				expectation.fulfill()
			case .failure(_):
				break
			}
		}
		waitForExpectations(timeout: 1, handler: nil)
		XCTAssertEqual(outputPlayers?[0].name, "Bobince")
	}
	
	func test_getEvents_correctParsing() {
		
		let expectation = self.expectation(description: "events expectation")
		var outputEvents: [Event]?
		
		stub(condition: isHost("thesportsdb.com")) { (_) -> HTTPStubsResponse in
			return HTTPStubsResponse(fileAtPath: OHPathForFile("events.json", type(of: self))!, statusCode: 200, headers: ["Content-Type": "application/json"])
		}
		
		sut.getEvents(teamID: "134880") { (res) in
			switch res {
			case .success(let events):
				outputEvents = events
				expectation.fulfill()
			case .failure(_):
				break
				}
			}
		waitForExpectations(timeout: 1, handler: nil)
		XCTAssertEqual(outputEvents?[0].homeTeamName, "Cool cats")
	}
	
}
