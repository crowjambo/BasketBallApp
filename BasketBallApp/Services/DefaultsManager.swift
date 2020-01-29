import Foundation

protocol LastUpdateTrackable {
	func shouldUpdate(idOfEntity: UpdateTime) -> Bool
	func updateTime(key: UpdateTime)
}

enum UpdateTime: String {
	case team = "1"
	case event = "2"
	case player = "3"
}

final class DefaultsManager: LastUpdateTrackable {
	
	let defaults = UserDefaults.standard
	
	func shouldUpdate(idOfEntity: UpdateTime) -> Bool {
		return true
		if var lastUpdated = defaults.object(forKey: idOfEntity.rawValue) as? Date {
			debugPrint(lastUpdated)

			switch idOfEntity {
			case .team:
					lastUpdated += 60 * 60
			case .event:
					lastUpdated += 60 * 15
			case .player:
					lastUpdated += 60 * 30
			}
			// older than designated update time
			if lastUpdated < Date() {
				return true
			} else {
				return false
			}
		}
		// first time launching, should update
		else {
			return true
		}
	}
	
	func updateTime(key: UpdateTime) {
		defaults.set(Date(), forKey: key.rawValue)
	}
}
