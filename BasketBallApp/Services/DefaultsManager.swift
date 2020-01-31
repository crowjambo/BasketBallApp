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
	
	var updateTimeForTeams: TimeInterval
	var updateTimeForEvents: TimeInterval
	var updateTimeForPlayers: TimeInterval
	
	init(updateTimeForTeams: TimeInterval = 3600, updateTimeForEvents: TimeInterval = 900, updateTimeForPlayers: TimeInterval = 1800) {
		
		self.updateTimeForTeams = updateTimeForTeams
		self.updateTimeForEvents = updateTimeForEvents
		self.updateTimeForPlayers = updateTimeForPlayers
	}
	
	let defaults = UserDefaults.standard
	
	func shouldUpdate(idOfEntity: UpdateTime) -> Bool {

		if var lastUpdated = defaults.object(forKey: idOfEntity.rawValue) as? Date {

			switch idOfEntity {
			case .team:
					lastUpdated += updateTimeForTeams
			case .event:
					lastUpdated += updateTimeForEvents
			case .player:
					lastUpdated += updateTimeForPlayers
			}
			// older than designated update time
			return lastUpdated < Date()
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
