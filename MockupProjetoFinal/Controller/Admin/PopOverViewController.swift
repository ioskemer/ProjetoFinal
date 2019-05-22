import UIKit
import SwiftyJSON

class PopOverViewController: UITableViewController {
    var teste = ""
    var info: [JSON] = []
    
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
        return self.info.count;
    }
    
    
    // Select item from tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //Assign values for tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let userName = info[indexPath.row]["name"].stringValue
        let userCpf = info[indexPath.row]["cpf"].stringValue
        let userQuantity = info[indexPath.row]["quantity"].stringValue
        
        cell.textLabel?.text = "\(userName) - \(userCpf) - \(userQuantity)"
        
        return cell
    }
}
