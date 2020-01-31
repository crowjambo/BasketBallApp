import Foundation
@testable import BasketBallApp

class MockUserDefaults: LastUpdateTrackable {
	
	var shouldTeamReturnFromApi: Bool
	var shouldPlayerReturnFromApi: Bool
	var shouldEventReturnFromApi: Bool
	
	init(teamReturn: Bool = true, playerReturn: Bool = true, eventReturn: Bool = true) {
		self.shouldTeamReturnFromApi = teamReturn
		self.shouldPlayerReturnFromApi = playerReturn
		self.shouldEventReturnFromApi = eventReturn
	}
	
	func shouldUpdate(idOfEntity: UpdateTime) -> Bool {
		switch idOfEntity {
		case .team:
			return shouldTeamReturnFromApi
		case .event:
			return shouldPlayerReturnFromApi
		case .player:
			return shouldEventReturnFromApi
		}
	}
	
	func updateTime(key: UpdateTime) {
		return
	}
	
}
