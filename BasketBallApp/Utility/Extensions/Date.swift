import Foundation


extension Date {
		
	static func getAgeFromDateOfBirth(date: String) -> String {
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-mm-dd"
		let formattedDate = formatter.date(from: date)

		let calendar = Calendar.current
		let components = calendar.dateComponents([.year], from: formattedDate ?? Date(), to: Date())
		
		let finalDate = calendar.date(from: components)
		
		formatter.dateFormat = "y"
		
		guard let outputAge = finalDate else { return " - "}
		
		return formatter.string(from: outputAge)
		
	}
}
