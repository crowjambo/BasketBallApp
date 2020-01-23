import UIKit

class MainViewController: UIViewController {
	
	// MARK: - Variables
	
	var teams: [Team]?
	
	// MARK: - Outlets
	
	@IBOutlet weak var cardCollectionView: UICollectionView!
	
	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()

	}
		
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			let destinationController = segue.destination as? TeamInfoViewController,
			let selectedCell = sender as? TeamCollectionCell,
			let indexPath = cardCollectionView.indexPath(for: selectedCell),
			let teams = teams
			else { return }
		
		let selectedTeam = teams[indexPath.row]
		destinationController.team = selectedTeam
	}
	
	func loadData() {
		
		let dlm = DataLoadingManager()
		dlm.loadData { (teamsRet) in
			self.teams = teamsRet
			
			DispatchQueue.main.async {
				self.cardCollectionView.reloadData()
			}
		}
	}
}

// MARK: - CollectionView setup

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let teams = teams else { return 0 }
		return teams.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionCell", for: indexPath) as? TeamCollectionCell {
			if let teams = teams {
				let team = teams[indexPath.row]
				cell.styleItself(teamName: team.teamName, teamDescription: team.description, teamIcon: team.imageIconName)
			}
			return cell
		} else {
			return UICollectionViewCell()
		}
	}
}
