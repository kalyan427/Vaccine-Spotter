
import UIKit

class StatesListViewController: UIViewController {
    @IBOutlet weak var tbleVIew: UITableView!
    var stateManager = StatesManager()
    var stateList:[StateNameList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stateManager.getListOfStates { (list) in
            self.stateList = list
            DispatchQueue.main.async {
                self.tbleVIew.reloadData()
            }
        }
    }
}

extension StatesListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stateList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.stateList![indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapDisplayController = (self.storyboard?.instantiateViewController(identifier: "vc"))! as ViewController
        mapDisplayController.selectedState = self.stateList![indexPath.row]
        self.navigationController?.pushViewController(mapDisplayController, animated: true)
    }
}
