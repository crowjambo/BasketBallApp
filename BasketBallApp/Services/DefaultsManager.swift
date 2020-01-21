import Foundation

enum UpdateTime : String{
	case Team = "1"
	case Event = "2"
	case Player = "3"
}

final class DefaultsManager{
	
	static let defaults = UserDefaults.standard
	
	class func shouldUpdate(id: UpdateTime) -> Bool{
		
		//TEMP FOR TESTING API
		return true
		
		if var lastUpdated = defaults.object(forKey: id.rawValue) as? Date{
			switch id {
				case .Team:
					lastUpdated += 60 * 60
				case .Event:
					lastUpdated += 60 * 15
				case .Player:
					lastUpdated += 60 * 30
			}
			// older than designated update time
			if lastUpdated < Date() {
				return true
			}
			else{
				return false
			}
		}
		// first time launching, should update
		else{
			return true
		}
	}
	
	class func updateTime(key: String){
		defaults.set(Date(), forKey: key)
	}
}
