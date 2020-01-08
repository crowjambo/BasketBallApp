import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	//main collection (could be database or in another file)
	var teams: [TeamInfo] = []
	
	//get tableView so we can call its reload method later for updating UI
	@IBOutlet weak var tableViewOutlet: UITableView!
	
	// default controller function
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		// move all of this to separate model file later
		teams.append(TeamInfo(teamName: "test", description: "adsasdasdasd"))
		
		
	}
	
	//set custom values and init the cell (on each reload) (MAIN CELL CREATION FUNCTION)
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "TeamInfoCell", for: indexPath) as! TeamInfoTableCell
		
		// set that new cell values
		cell.titleTeamNameOutlet.text = teams[indexPath.row].teamName
		cell.teamDescriptionOutlet.text = teams[indexPath.row].description
		
		
		
		// one cell is created
		return cell
	}
	
	//number of items in tableView (helper function for implementation of UITableView)
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return teams.count
	}
	

}



