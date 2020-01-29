import Foundation
import RealmSwift

class RealmTeam: Object {
	
	required init() {
		
	}
	
	@objc dynamic var teamID: String? = nil
	@objc dynamic var teamName: String? = nil
	@objc dynamic var teamDescription: String? = nil
	@objc dynamic var imageIconName: String? = nil
	@objc dynamic var imageTeamMain: String? = nil
	
	override static func primaryKey() -> String? {
		return "teamID"
	}

	let teamPlayers = List<RealmPlayer>()
	let matchHistory = List<RealmEvent>()

}

class RealmPlayer: Object {
	
	required init() {
		
	}
	
	@objc dynamic var name: String? = nil
	@objc dynamic var age: String? = nil
	@objc dynamic var height: String? = nil
	@objc dynamic var weight: String? = nil
	@objc dynamic var playerDescription: String? = nil
	@objc dynamic var position: String? = nil
	@objc dynamic var playerIconImage: String? = nil
	@objc dynamic var playerMainImage: String? = nil
	
	
}

class RealmEvent: Object {
	
	required init() {
		
	}
	
	@objc dynamic var  homeTeamName: String? = nil
	@objc dynamic var  awayTeamName: String? = nil
	@objc dynamic var  date: String? = nil
	
	
}
