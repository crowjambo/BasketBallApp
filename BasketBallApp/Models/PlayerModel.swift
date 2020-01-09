import Foundation


class Player{
	var name:String?
	var age:Int?
	var height:Int?
	var weight:Int?
	var description:String?
	var position:String?
	var playerIconImage:String?
	var playerMainImage:String?
	
	convenience init(name:String,age:Int,height:Int,weight:Int, description:String, position:String, playerIconImage:String, playerMainImage:String) {
		self.init()
		self.name = name
		self.age = age
		self.height = height
		self.weight = weight
		self.description = description
		self.position = position
		self.playerIconImage = playerIconImage
		self.playerMainImage = playerMainImage
	}
}
