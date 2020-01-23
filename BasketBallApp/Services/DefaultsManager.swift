import Foundation

enum UpdateTime: String {
	case team = "1"
	case event = "2"
	case player = "3"
}

// TODO: use dependency injection to make this testable
final class DefaultsManager {
	
	static let defaults = UserDefaults.standard
	
	class func shouldUpdate(id: UpdateTime) -> Bool {
		
		if var lastUpdated = defaults.object(forKey: id.rawValue) as? Date {
			switch id {
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
	
	class func updateTime(key: UpdateTime) {
		defaults.set(Date(), forKey: key.rawValue)
	}
}
