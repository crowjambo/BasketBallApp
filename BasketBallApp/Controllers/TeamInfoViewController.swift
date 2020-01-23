import UIKit

class TeamInfoViewController: UIViewController {

	// MARK: - Variables
	
	var team: Team?
	
	// MARK: - Outlets
	
	// TODO: Clean up and align the Outlets in Storyboard for Teams names displaying
	
	@IBOutlet weak var teamNameLabelOutlet: UILabel!
	@IBOutlet weak var mainTeamImageOutlet: UIImageView!
	@IBOutlet weak var tableOutlet: UITableView!
	@IBOutlet weak var segmentOutlet: UISegmentedControl!
	
	// MARK: - View Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setViewData()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		guard
			let vc = segue.destination as? PlayerDetailViewController,
			let selectedCell = sender as? PlayerCell,
			let indexPath = tableOutlet.indexPath(for: selectedCell),
			let team = team,
			let teamPlayers = team.teamPlayers
		else { return }
			
		let selectedPlayer = teamPlayers[indexPath.row]
		vc.player = selectedPlayer
	}
	
	// MARK: - Functions
	
	func setViewData() {
		if let name = team?.teamName {
			teamNameLabelOutlet.text = name
		}
		
		if let mainImageName = team?.imageTeamMain {
			let url = URL(string: mainImageName)
			mainTeamImageOutlet.load(url: url!)
		}
	}

	// MARK: - User interaction

	@IBAction func segmentPress(_ sender: Any) {
		var cellHeight: Float = 0
		switch segmentOutlet.selectedSegmentIndex {
		case 0:
				cellHeight = 100
		case 1:
				cellHeight = 50
		default:
				cellHeight = 100
		}
		tableOutlet.rowHeight = CGFloat(cellHeight)
		tableOutlet.reloadData()
	}

}

// MARK: - TableView setup

extension TeamInfoViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		switch segmentOutlet.selectedSegmentIndex {
		case 0:
				guard let rowsCount = team?.matchHistory?.count else {
					return 0
				}
				return rowsCount
		case 1:
				guard let rowsCount = team?.teamPlayers?.count else {
					return 0
				}
				return rowsCount
		default:
				return 0
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch segmentOutlet.selectedSegmentIndex {
		case 0:
				let cell = tableView.dequeueReusableCell(withIdentifier: "MatchInfoCell", for: indexPath) as? EventCell
				cell?.styleItself(dateLabel: team?.matchHistory?[indexPath.row].date, homeTeamName: team?.matchHistory?[indexPath.row].homeTeamName, awayTeamName: team?.matchHistory?[indexPath.row].awayTeamName)
				return cell ?? UITableViewCell()
			
		case 1:
				let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerInfoCell", for: indexPath) as? PlayerCell
				cell?.styleItself(playerImage: team?.teamPlayers?[indexPath.row].playerIconImage, name: team?.teamPlayers?[indexPath.row].name, position: team?.teamPlayers?[indexPath.row].position)
				return cell ?? UITableViewCell()
		default:
				return UITableViewCell()
		}

	}
}
