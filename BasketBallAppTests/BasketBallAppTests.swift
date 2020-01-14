import XCTest
@testable import BasketBallApp

class BasketBallAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		let someVar = "Hello"
		
		XCTAssertEqual("Hello", someVar)
    }
	
	
	
	func test_MatchHistory_gibberish_team1name_init(){
		let name = "testasbd1123[]23#@#@#absd"
		
		let mh = MatchHistory(team1Name: name, team2Name: nil, date: nil)
		
		XCTAssertEqual(mh.team1Name, name)
		
	}
	
	func test_MatchHistory_gibberish_team2name_init(){
		let name = "tesdfssdf234123[]///asdzxc..."
		
		let mh = MatchHistory(team1Name: nil, team2Name: name, date: nil)
		
		XCTAssertEqual(mh.team2Name, name)
	}
	
	func test_MatchHistory_gibberish_date_init(){
		let name = "tesdfssdf234123[]///asdzxc..."
		
		let mh = MatchHistory(team1Name: nil, team2Name: nil, date: name)
		
		XCTAssertEqual(mh.date, name)
	}
	
	func test_teams_appending(){
		var teams: [TeamInfo] = []
		teams.append(TeamInfo(teamName: "test", description: "test", imageIconName: "square", imageTeamMain: "test"))
		teams.append(TeamInfo(teamName: "test", description: "test", imageIconName: "square", imageTeamMain: "test"))
		teams.append(TeamInfo(teamName: "test", description: "test", imageIconName: "square", imageTeamMain: "test"))
		
		XCTAssertEqual(3, teams.count)
	}
	
	
	func test_LoadingDataFromDatabase(){
		let data = TeamsDatabase.LoadFakeData()
		
		XCTAssertNotNil(data)
	}
	
	func test_loadedFakeDataIsRequiredType(){
		let data = TeamsDatabase.LoadFakeData()
	
		
		XCTAssertTrue(data is [TeamInfo])
	}

	
	
    func testPerformanceExample() {
        // This is an ex ample of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
