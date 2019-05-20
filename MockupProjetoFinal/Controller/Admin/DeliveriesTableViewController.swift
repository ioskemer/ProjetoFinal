//
//  DeliveriesTableViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 15/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class DeliveriesTableViewController: UITableViewController {
    let ref = Database.database().reference()
    var dataArray:[Batch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateData(){
        var count = 0
        dataArray = []
        ref.child("batches").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSArray
            
            for batch in value! {
                if count == 0{
                    count = 1
                } else {
                    let jsonBatch = JSON(batch)
                    let newBatch = Batch()
                    newBatch.id = Int(jsonBatch["id"].stringValue)!
                    newBatch.title = jsonBatch["title"].stringValue
                    newBatch.status = jsonBatch["batchStatus"].stringValue
                    
                    if (newBatch.status == "closed"){
                        self.dataArray.append(newBatch)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let batch = dataArray[indexPath.row]
        cell.textLabel?.text = batch.title.capitalized

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "deliverBatchInfo" {
            let vc : DeliverBatchInfoViewController = segue.destination as! DeliverBatchInfoViewController
            
            vc.batch = dataArray[tableView.indexPathForSelectedRow!.row]
        }
    }

}
