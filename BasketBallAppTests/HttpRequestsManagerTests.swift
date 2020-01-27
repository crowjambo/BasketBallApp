import XCTest
import Foundation
import Alamofire
import OHHTTPStubs

// TODO: learn to set up HTTPStubs for easier testing?

@testable import BasketBallApp

class HttpRequestsManagerTests: XCTestCase {
	
	var sut: HttpRequestsManager!
	
    override func setUp() {
		sut = HttpRequestsManager()
    }

    override func tearDown() {
		sut = nil
		HTTPStubs.removeAllStubs()
    }
	
	func test_stubbing_moreTest3() {
			stub(condition: isHost("thesportsdb.com")) { (_) -> HTTPStubsResponse in
	//			let stubData = "Hello World".data(using: String.Encoding.utf8)
	//			return HTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
	//			return HTTPStubsResponse(jsonObject: ["teamName": "AtlantaTest"], statusCode: 200, headers: ["Content-Type": "application/json"])
				return HTTPStubsResponse(fileAtPath: OHPathForFile("teams2.json", type(of: self))!, statusCode: 200, headers: ["Content-Type":"application/json"])
			}
		
		sut.getTeams { (res) in
			
		}
	}
	
	func test_stubbing_moreTests2() {
		let expectation = self.expectation(description: "tst")
//
//		stub(condition: isHost("thesportsdb.com")) { (_) -> HTTPStubsResponse in
//			return HTTPStubsResponse(fileAtPath: OHPathForFile("teams2.json", type(of: self))!, statusCode: 200, headers: ["Content-Type": "application/json"])
//		}
		
//				let expectation = self.expectation(description: "tst")
//				var output: String?
//
//				stub(condition: isHost("jsonplaceholder.typicode.com")) { (_) -> HTTPStubsResponse in
//					let stubData = "Hello World".data(using: String.Encoding.utf8)
//					return HTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
//				}
//
//				guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
//				AF.request(url, method: .get).responseJSON { (response) in
//		//			debugPrint(String(decoding: response.data!, as: UTF8.self))
//					do {
//						guard let data = response.data else { return }
//		//				let teams = try JSONDecoder().decode(TeamsJsonResponse.self, from: data)
//						output = String(decoding: data, as: UTF8.self)
//						expectation.fulfill()
//						} catch {
//							debugPrint(error)
//						}
//				}
//				waitForExpectations(timeout: 2, handler: nil)
//				debugPrint(output)
//				XCTAssertNotNil(output)
		
		stub(condition: isHost("thesportsdb.com")) { (_) -> HTTPStubsResponse in
//			let stubData = "Hello World".data(using: String.Encoding.utf8)
//			return HTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
//			return HTTPStubsResponse(jsonObject: ["teamName": "AtlantaTest"], statusCode: 200, headers: ["Content-Type": "application/json"])
			return HTTPStubsResponse(fileAtPath: OHPathForFile("teams2.json", type(of: self))!, statusCode: 200, headers: ["Content-Type":"application/json"])
		}
		
		var outputTeams: [Team]?
//		"https://www.thesportsdb.com/api/v1/json/1/search_all_teams.php?l=NBA"
		guard let url = URL(string: "https://thesportsdb.com/api/v1/json/1/search_all_teams.php?l=NBA") else { return }
		AF.request(url, method: .get).responseJSON { (response) in
			let somedata = String(decoding: response.data! , as: UTF8.self)
			debugPrint(somedata)
			expectation.fulfill()
//			debugPrint(String(decoding: response.data!, as: UTF8.self))
//			do {
//				guard let data = response.data else { return }
//				let dataString = String(decoding: data, as: UTF8.self)
//				debugPrint(dataString)
//				let teams = try JSONDecoder().decode(TeamsJsonResponse.self, from: data)
//				outputTeams = teams.teams
//				output = String(decoding: data, as: UTF8.self)
//				expectation.fulfill()
//				} catch {
//					debugPrint(error)
//				}
		}
		waitForExpectations(timeout: 1, handler: nil)
//		debugPrint(outputTeams![0].teamName!)
//		XCTAssertEqual(outputTeams![0].teamName!, "Atlanta Hawks")
		
		
	}
	
//	func test_stubbing_moreTests() {
//		let expectation = self.expectation(description: "loading")
//
//		stub(condition: isHost("thesportsdb.com")) { (_) -> HTTPStubsResponse in
//			return HTTPStubsResponse(fileAtPath: OHPathForFile("teams.json", type(of: self))!, statusCode: 200, headers: ["Content-Type":"application/json"])
//		}
//
//		var outputTeams: [Team]?
//
//		guard let url = URL(string: "https://www.thesportsdb.com/api/v1/json/1/search_all_teams.php?l=NBA") else { return }
//
//		sut.getTeams { (res) in
//			switch res{
//			case .success(let teams):
//			outputTeams = teams
//			expectation.fulfill()
//			case .failure(let err): break
//			}
//			debugPrint(outputTeams!)
//		}
//
//		waitForExpectations(timeout: 2, handler: nil)
//
//	}
	
//	func test_stubbing_jsonFile() {
//		let expectation = self.expectation(description: "tst")
//
//		stub(condition: isHost("thesportsdb.com")) { (_) -> HTTPStubsResponse in
//			return HTTPStubsResponse(fileAtPath: OHPathForFile("teams.json", type(of: self))!, statusCode: 200, headers: ["Content-Type":"application/json"])
//		}
//
//		var outputTeams: [Team]?
//
//		guard let url = URL(string: "https://www.thesportsdb.com/api/v1/json/1/search_all_teams.php?l=NBA") else { return }
//		AF.request(url, method: .get).responseJSON { (response) in
////			debugPrint(String(decoding: response.data!, as: UTF8.self))
//			do {
//				guard let data = response.data else { return }
//				let teams = try JSONDecoder().decode(TeamsJsonResponse.self, from: data)
//				outputTeams = teams.teams
////				output = String(decoding: data, as: UTF8.self)
//				expectation.fulfill()
//				} catch {
//					debugPrint(error)
//				}
//		}
//		waitForExpectations(timeout: 1, handler: nil)
////		debugPrint(outputTeams![0].teamName!)
//		XCTAssertEqual(outputTeams![0].teamName!, "Atlanta Hawks")
//	}
	
	func test_stubbing() {
		let expectation = self.expectation(description: "tst")
		var output: String?
		
		stub(condition: isHost("jsonplaceholder.typicode.com")) { (_) -> HTTPStubsResponse in
			let stubData = "Hello World".data(using: String.Encoding.utf8)
			return HTTPStubsResponse(data: stubData!, statusCode: 200, headers: nil)
		}
		
		guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
		AF.request(url, method: .get).responseJSON { (response) in
//			debugPrint(String(decoding: response.data!, as: UTF8.self))
			do {
				guard let data = response.data else { return }
//				let teams = try JSONDecoder().decode(TeamsJsonResponse.self, from: data)
				output = String(decoding: data, as: UTF8.self)
				expectation.fulfill()
				} catch {
					debugPrint(error)
				}
		}
		waitForExpectations(timeout: 2, handler: nil)
		debugPrint(output)
		XCTAssertNotNil(output)
	}
	
	func test_getTeams_correctParsing() {
		//mock some json reading
		//parse using JSONDecoder
		//check if completion handler returns proper data w/assert
		//mock inject AF.request method
		
	}
	
	func test_getPlayers_correctParsing() {
		//same as above
		// I dont need to test Alamofire requests, just my own parsing
		//mock inject AF.request method
	}
	
	func test_getEvents_correctParsing() {
		//same as above
		//mock inject AF.request method
	}
	
	func test_getAllTeamsPlayers_AllTeamsReturned() {
		//mock/inject getPlayers method
	}
	
	func test_getAllTeamsEvents_AllTeamsReturned() {
		//mock/inject getEvents method
	}
	//
	
	func test_get_request_loadTeams_Alamofire_names_match() {
		var teamsCol: [Team]?
		let expectation = self.expectation(description: "loading")
		
		sut.getTeams { (res) in
			switch res {
			case .success(let teams):
				teamsCol = teams
			case .failure(let err):
				XCTFail()
			}
			
			expectation.fulfill()
		}
		waitForExpectations(timeout: 2, handler: nil)
		XCTAssertEqual(teamsCol?.first?.teamName, "Atlanta Hawks")
	}
	
//	func test_get_request_loadPlayers_Alamofire_not_null() {
//		var playerCol: [Player]?
//		let expectation = self.expectation(description: "loading")
//
//		HttpRequestsManager.getPlayers(teamName: "Atlanta Hawks") { (players, _) in
//			playerCol = players
//
//			expectation.fulfill()
//		}
//		waitForExpectations(timeout: 2, handler: nil)
//		XCTAssertNotNil(playerCol)
//	}
//
//	func test_get_request_loadMatches_Alamofire_not_null() {
//		var matchesCollection: [Event]?
//		let expectation = self.expectation(description: "loading")
//
//		HttpRequestsManager.getEvents(teamID: "134881") { (matches, _) in
//			matchesCollection = matches
//
//			expectation.fulfill()
//		}
//		waitForExpectations(timeout: 2, handler: nil)
//		XCTAssertNotNil(matchesCollection)
//	}
//
//	func test_get_request_loadTeams_Alamofire_not_null() {
//		var teamsCollection: [Team]?
//		let expectation = self.expectation(description: "loading")
//
//		HttpRequestsManager.getTeams { (teams, _) in
//			teamsCollection = teams
//
//			expectation.fulfill()
//		}
//
//		waitForExpectations(timeout: 2, handler: nil)
//		XCTAssertNotNil(teamsCollection)
//	}

}

