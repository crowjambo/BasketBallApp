import Foundation
@testable import BasketBallApp

class MockUserDefaults: LastUpdateTrackable {
	func shouldUpdate(idOfEntity: UpdateTime) -> Bool {
		return true
	}
	
	func updateTime(key: UpdateTime) {
		return
	}
	
}
