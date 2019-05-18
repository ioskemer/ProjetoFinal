//
//  DeliverBatchInfoViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 17/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class DeliverBatchInfoViewController: UIViewController {
    var batch = Batch()
    var usersArray = [String]()
    var addressArray = [String]()
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = batch.city
        
        getBatches()
    }

    func getBatches(){
        ref.child("batches").child(String(batch.id)).child("reserved").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
        
            if value == nil {
                return
            }
        
            for user in JSON(value!) {
                let jsonUser = JSON(user.1)
                
                let userId = jsonUser["uid"].stringValue
                self.usersArray.append(userId)
            }
            
            self.loadBatches()
        })
    }
    
    func loadBatches(){
        addressArray = []
        
        let unique = Array(Set(usersArray))
        for userId in unique {
            ref.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                if value == nil {
                    return
                }
                
                let jsonUser = JSON(value!)

                let address = jsonUser["address"].stringValue
                let cep = jsonUser["cep"].stringValue
                let number = jsonUser["number"].stringValue
                let city = jsonUser["city"].stringValue
                
                let fullAddress = "\(address), \(number), \(cep), \(city)"

                self.addressArray.append(fullAddress)
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
