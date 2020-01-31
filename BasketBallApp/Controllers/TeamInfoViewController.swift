import UIKit
import Kingfisher

class TeamInfoViewController: UIViewController {

	// MARK: - Variables
	
	var team: Team?
	var refreshControl: UIRefreshControl?
	var dataLoadingManager: TeamsDataLoadable?
	
	// MARK: - Outlets
		
	@IBOutlet weak var teamNameLabelOutlet: UILabel!
	@IBOutlet weak var mainTeamImageOutlet: UIImageView!
	@IBOutlet weak var tableOutlet: UITableView!
	@IBOutlet weak var segmentOutlet: UISegmentedControl!
	
	// MARK: - View Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		loadData()
		setupNavigationTitleImage()
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		guard
			let destinationController = segue.destination as? PlayerDetailViewController,
			let selectedCell = sender as? PlayerCell,
			let indexPath = tableOutlet.indexPath(for: selectedCell),
			let team = team,
			let teamPlayers = team.teamPlayers
		else { return }
			
		let selectedPlayer = teamPlayers[indexPath.row]
		destinationController.player = selectedPlayer
	}
	
	// MARK: - Functions
	
	func loadData() {
		if let name = team?.teamName {
			teamNameLabelOutlet.text = name
		}
		
		if let mainImageName = team?.imageTeamMain {
			let url = URL(string: mainImageName)
			mainTeamImageOutlet.kf.setImage(with: url)
		}
		addRefreshControl()
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

	// MARK: - Refresh control
	
	private func addRefreshControl() {
		
		refreshControl = UIRefreshControl()
		guard let refreshControl = refreshControl else { return }
		refreshControl.tintColor = UIColor.red
		refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
		tableOutlet.addSubview(refreshControl)
	}

	@objc func refreshList() {
		
		guard
			let dataLoadingManager = dataLoadingManager,
			let team = team
			else {
			view.makeToast("Failed to refresh", duration: 3.0)
			return
		}
		dataLoadingManager.requestsManager.getPlayers(teamName: team.teamName!, completionHandler: { (res) in
			switch res {
			case .success(let players):
				self.team?.teamPlayers = players
			case .failure(_):
			break
			}
			
			dataLoadingManager.requestsManager.getEvents(teamID: team.teamID!, completionHandler: { (res) in
				switch res {
				case .success(let events):
					self.team?.matchHistory = events
				case .failure(_):
				break
				}
				self.tableOutlet.reloadData()
				self.refreshControl?.endRefreshing()
			})
		})
		

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
