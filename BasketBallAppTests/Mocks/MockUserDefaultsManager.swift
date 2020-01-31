import Foundation
@testable import BasketBallApp

class MockUserDefaults: LastUpdateTrackable {
	
	var teamReturn: Bool
	var playerReturn: Bool
	var eventReturn: Bool
	
	init(teamReturn: Bool = true, playerReturn: Bool = true, eventReturn: Bool = true) {
		self.teamReturn = teamReturn
		self.playerReturn = playerReturn
		self.eventReturn = eventReturn
	}
	
	func shouldUpdate(idOfEntity: UpdateTime) -> Bool {
		switch idOfEntity {
		case .team:
			return teamReturn
		case .event:
			return playerReturn
		case .player:
			return eventReturn
		}
	}
	
	func updateTime(key: UpdateTime) {
		return
	}
	
}
