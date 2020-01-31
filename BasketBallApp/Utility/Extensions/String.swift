import Foundation

extension String {
	
	static func splitHeight(height: String) -> String {
		let array = height.components(separatedBy: "(")
		return array[0]
	}
	
	static func splitWeight(weight: String) -> String {
		let array = weight.components(separatedBy: " ")
		return array[0]
	}
	
}
