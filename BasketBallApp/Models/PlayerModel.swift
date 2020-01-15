import Foundation


struct Player : Decodable{
	var name:String?
	var age:String?
	var height:String?
	var weight:String?
	var description:String?
	var position:String?
	var playerIconImage:String?
	var playerMainImage:String?
	
	enum CodingKeys: String, CodingKey{
		case name = "strPlayer"
		case age = "dateBorn"
		case height = "strHeight"
		case weight = "strWeight"
		case description = "strDescriptionEN"
		case position = "strPosition"
		case playerIconImage = "strCutout"
		case playerMainImage = "strThumb"
		
	}
}
