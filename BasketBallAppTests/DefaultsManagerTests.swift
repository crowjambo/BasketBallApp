import XCTest
@testable import BasketBallApp

class DefaultsManagerTests: XCTestCase {

	var sut: DefaultsManager!
	
    override func setUp() {
		sut = DefaultsManager()
    }

    override func tearDown() {
		sut = nil
    }
	
	func test_ReturnsTeamsShouldUpdate_True() {
		
	}
	
	func test_ReturnsPlayersShouldUpdate_True() {
		
	}
	
	func test_ReturnsEventsShouldUpdate_True() {
		
	}
	
	func test_ReturnsTeamsShouldUpdate_False() {
		
	}
	
	func test_ReturnsPlayersShouldUpdate_False() {
		
	}
	
	func test_ReturnsEventsShouldUpdate_False() {
		
	}

}
