//
//  MyCardsTableViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 10/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class MyCardsTableViewController: UITableViewController {
    var myCards = ["Mastercard com final 4325", "Visa com final 9684", "Sodexo com final 1054"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let buttonAdd = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.addCredtiCard))
        
        self.navigationItem.rightBarButtonItems = [buttonAdd]
    }

    @objc func addCredtiCard(){
        performSegue(withIdentifier: "newCreditCard", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myCards.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardRow", for: indexPath)

        cell.textLabel?.text = myCards[indexPath.row]

        return cell
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
        //var note = reminderNotes[self.selectedRow]
        
        if segue.identifier == "newCreditCard" {
            let vc : CreditCardViewController = segue.destination as! CreditCardViewController
            
            vc.isNew = "true"
           } else if segue.identifier == "editCreditCard" {
            let vc : CreditCardViewController = segue.destination as! CreditCardViewController
            
            vc.isNew = "false"
        }
    }

}
