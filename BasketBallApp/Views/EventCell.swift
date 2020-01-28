import UIKit

class EventCell: UITableViewCell {
	
	@IBOutlet weak var dateLabelOutlet: UILabel!
	@IBOutlet weak var eventNameOutlet: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func styleItself(dateLabel: String?, homeTeamName: String?, awayTeamName: String?) {
		guard
			let homeTeamName = homeTeamName,
			let awayTeamName = awayTeamName,
			let dateLabel = dateLabel
			else { return }
		
		dateLabelOutlet.text = dateLabel
		eventNameOutlet.text = "\(homeTeamName)   VS   \(awayTeamName)"
	}

}
