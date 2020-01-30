import UIKit
import Toast_Swift

class MainViewController: UIViewController {
	
	// MARK: - Variables
	
	var teams: [Team]? {
		didSet {
			cardCollectionView.reloadData()
		}
	}
	var displayLinear: Bool = true
	
	var refreshControl: UIRefreshControl?
	
	var dataLoadingManager: TeamsDataLoadable?
	
	// MARK: - Outlets
	
	@IBOutlet weak var cardCollectionView: UICollectionView!
	
	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationTitleImage()
		addRefreshControl()
		loadData()

	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			let destinationController = segue.destination as? TeamInfoViewController,
			let selectedCell = sender as? UICollectionViewCell,
			let indexPath = cardCollectionView.indexPath(for: selectedCell),
			let teams = teams
			else { return }
		
		let selectedTeam = teams[indexPath.row]
		destinationController.team = selectedTeam
	}
	
	func loadData() {
		
		dataLoadingManager?.loadData(completionHandler: { [weak self] (res) in
			switch res {
			case .success(let teams):
				self?.teams = teams
			case .failure(let err):
				self?.teams = []
				self?.view.makeToast("Failed to load teams", duration: 3.0, position: .bottom)
				debugPrint(err)
			}
			
			DispatchQueue.main.async {
				self?.cardCollectionView.reloadData()
			}

		})
	}
	
	// MARK: - Refresh control
	
	private func addRefreshControl() {
		
		refreshControl = UIRefreshControl()
		guard let refreshControl = refreshControl else { return }
		refreshControl.tintColor = UIColor.red
		refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
		cardCollectionView.addSubview(refreshControl)
	}

	@objc func refreshList() {
		dataLoadingManager?.requestsManager.getTeams(baseApiURL: "https://www.thesportsdb.com/api/v1/json/1/", url: "search_all_teams.php?l=NBA", completionHandler: { (res) in
			switch res {
			case .success(let teams):
				self.teams = teams
			case .failure(let err):
			break
			}
			
			self.dataLoadingManager?.requestsManager.getAllTeamsPlayersApi(teams: self.teams, completionHandler: { (res) in
				switch res {
				case .success(let teams):
					self.teams = teams
				case .failure(let err):
				break
			}
				
				self.dataLoadingManager?.requestsManager.getAllTeamsEventsApi(teams: self.teams, completionHandler: { (res) in
					switch res {
					case .success(let teams):
						self.teams = teams
					case .failure(let err):
					break
					}
				})
			})
			
		})
		self.cardCollectionView.reloadData()
		refreshControl?.endRefreshing()
	}
	
	// MARK: - Navigation bar image
	
	func setupNavigationTitleImage() {
		
		let titleImageView = UIImageView(image: #imageLiteral(resourceName: "nbalogo") )
		titleImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
		titleImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
		titleImageView.contentMode = .scaleAspectFit
		navigationItem.titleView = titleImageView
		 
	  }
	
	// MARK: - Layout buttons actions
	
	@IBAction func linearLayoutAction(_ sender: Any) {
		displayLinear = true
		cardCollectionView.reloadData()
	}
	
	@IBAction func gridLayoutAction(_ sender: Any) {
		displayLinear = false
		cardCollectionView.reloadData()
	}
	
}

// MARK: - CollectionView setup

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let teams = teams else { return 0 }
		return teams.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		if displayLinear {
			if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionCell", for: indexPath) as? TeamCollectionCell {
				if let teams = teams {
					let team = teams[indexPath.row]
					cell.styleItself(teamName: team.teamName, teamDescription: team.description, teamIcon: team.imageIconName)
				}
				return cell
			} else {
				return UICollectionViewCell()
			}
		} else {
			if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionSmallSquareCell", for: indexPath) as? TeamCollectionSmallSquareCell {
				if let teams = teams {
					let team = teams[indexPath.row]
					cell.styleItself(teamIcon: team.imageIconName)
				}
				return cell
			} else {
				return UICollectionViewCell()
			}
		}
		
	}
}
