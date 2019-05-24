//
//  BuyBatchViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 15/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class BuyBatchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var batch = Batch()
    var userCards = ["Mastercard com final 4325", "Visa com final 1984", "Elo com final 2958", "Sodexo com final 2157"]
    var ref = Database.database().reference()
    
    @IBOutlet weak var selectedQuantity: UILabel!
    @IBOutlet weak var batchQuantity: UISlider!
    @IBOutlet weak var userCard: UIPickerView!
    @IBOutlet weak var totalPrice: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let availableUnits = batch.availableQuantity
        batchQuantity.maximumValue = Float(availableUnits)
        batchQuantity.minimumValue = 1
        selectedQuantity.text = "1"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return userCards[row]
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        selectedQuantity.text = String(Int(batchQuantity.value))
        totalPrice.text = "R$ " + String(batchQuantity.value * batch.price)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func reserveBatch(_ sender: Any) {
        let desiredQuantity = Int(batchQuantity.value)
        let userID = UserDefaults.standard.string(forKey: "currentUserId")
        //ref.child("batches").child(batch.id)
        var userCep = ""
        var userAddress = ""
        var userNumber = ""
        var userCpf = ""
        var userName = ""
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value == nil {
                return
            }
            let userData = JSON(value!)
            
            userCep = userData["cep"].stringValue
            userName = userData["name"].stringValue
            userAddress = userData["address"].stringValue
            userNumber = userData["number"].stringValue
            userCpf = userData["cpf"].stringValue
        })
        ref.child("batches").child(String(batch.id)).child("reserved").observeSingleEvent(of: .value, with: { (snapshot) in
            _ = snapshot.value as? NSDictionary
 
            let locationRef = self.ref.child("batches").child(String(self.batch.id)).child("reserved").childByAutoId()
            locationRef.setValue(["uid": userID!, "quantity": desiredQuantity, "cpf": userCpf, "address": "\(userAddress), \(userNumber), \(userCep)", "name": userName])
        })
        
        let locationRef = self.ref.child("users").child(userID!).child("batches").childByAutoId()
        locationRef.setValue(["batchId": batch.id, "quantity": desiredQuantity])
        
        batch.updateAvailableQuantity(Database.database(), desiredQuantity)
        
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
}
