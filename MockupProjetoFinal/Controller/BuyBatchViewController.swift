//
//  BuyBatchViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 15/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class BuyBatchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var batch = Batch()
    var userCards = ["Mastercard com final 4325", "Visa com final 1984", "Elo com final 2958", "Sodexo com final 2157"]
    
    @IBOutlet weak var selectedQuantity: UILabel!
    @IBOutlet weak var batchQuantity: UISlider!
    @IBOutlet weak var userCard: UIPickerView!
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let availableUnits = batch.quantity
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
    }
}
