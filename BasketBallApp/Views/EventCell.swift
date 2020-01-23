import UIKit

class EventCell: UITableViewCell {
	
	@IBOutlet weak var dateLabelOutlet: UILabel!
	@IBOutlet weak var team1NameOutlet: UILabel!
	@IBOutlet weak var team2NameOutlet: UILabel!
	
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
		team1NameOutlet.text = homeTeamName
		team2NameOutlet.text = awayTeamName
	}

}
