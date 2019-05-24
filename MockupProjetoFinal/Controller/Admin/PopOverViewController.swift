import UIKit
import SwiftyJSON

class PopOverViewController: UITableViewController {
    var teste = ""
    var info: [JSON] = []
    var batch = Batch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
                navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Returns count of items in tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoutingViewController.infoArray.count;
    }
    
    
    // Select item from tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RoutingViewController.infoArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if RoutingViewController.infoArray.count == 0 {
                batch.setDelivered()
            }
        }
    }
    
    //Assign values for tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let userName = RoutingViewController.infoArray[indexPath.row]["name"].stringValue
        let userCpf = RoutingViewController.infoArray[indexPath.row]["cpf"].stringValue
        let userQuantity = RoutingViewController.infoArray[indexPath.row]["quantity"].stringValue
        
        cell.textLabel?.text = "\(userName) - \(userCpf) - \(userQuantity)"
        
        return cell
    }
}
