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
	
	func styleItself(dateLabel:String?, team1Name:String?, team2Name:String?){
		if let team1Name = team1Name{
			team1NameOutlet.text = team1Name
		}
		if let team2Name = team2Name{
			team2NameOutlet.text = team2Name
		}
		if let dateLabel = dateLabel{
			dateLabelOutlet.text = dateLabel
		}
	}

}
