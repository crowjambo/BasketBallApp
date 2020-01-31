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
		sut.updateTime(key: UpdateTime.team)
		sut.updateTimeForTeams = 0
		XCTAssert(sut.shouldUpdate(idOfEntity: UpdateTime.team))
	}
	
	func test_ReturnsPlayersShouldUpdate_True() {
		sut.updateTime(key: UpdateTime.player)
		sut.updateTimeForPlayers = 0
		XCTAssert(sut.shouldUpdate(idOfEntity: UpdateTime.player))
	}
	
	func test_ReturnsEventsShouldUpdate_True() {
		sut.updateTime(key: UpdateTime.event)
		sut.updateTimeForEvents = 0
		XCTAssert(sut.shouldUpdate(idOfEntity: UpdateTime.event))
	}
	
	func test_ReturnsTeamsShouldUpdate_False() {
		sut.updateTime(key: UpdateTime.team)
		XCTAssertFalse(sut.shouldUpdate(idOfEntity: UpdateTime.team))
	}
	
	func test_ReturnsPlayersShouldUpdate_False() {
		sut.updateTime(key: UpdateTime.player)
		XCTAssertFalse(sut.shouldUpdate(idOfEntity: UpdateTime.player))
	}
	
	func test_ReturnsEventsShouldUpdate_False() {
		sut.updateTime(key: UpdateTime.event)
		XCTAssertFalse(sut.shouldUpdate(idOfEntity: UpdateTime.event))
	}

}
