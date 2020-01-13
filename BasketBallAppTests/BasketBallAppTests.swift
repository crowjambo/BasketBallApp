	
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
		
		var someVar = "Hello"
		
		XCTAssertEqual("Hello", someVar)
    }
	
	func testLoadingDataFromDatabase(){
		let data = TeamsDatabase.LoadFakeData()
		
		//XCTAssertNil(data)
		XCTAssertNotNil(data)
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
