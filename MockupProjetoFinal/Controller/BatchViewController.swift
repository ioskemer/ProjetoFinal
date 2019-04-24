//
//  BatchViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 03/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class BatchViewController: UIViewController {
    var teste = ""
    var batch = Batch()
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productAvailableQuantity: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTitle.text = batch.title
        productDescription.text = batch.description
        productPrice.text = String(batch.price)
        productQuantity.text = String(batch.quantity)
        productAvailableQuantity.text = String(batch.availableQuantity)
        if batch.availableQuantity == 0 {
            buyButton.isHidden = true
        }
    }
    
    @IBAction func goToBuySection(_ sender: Any) {
        performSegue(withIdentifier: "buy", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //var note = reminderNotes[self.selectedRow]
        
        if segue.identifier == "buy" {
            let vc : BuyBatchViewController = segue.destination as! BuyBatchViewController
            
            vc.batch = batch
        }
    }
    
}
