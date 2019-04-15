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

    override func viewDidLoad() {
        super.viewDidLoad()
        productTitle.text = batch.title
        productDescription.text = batch.description
        productPrice.text = String(batch.price)
        productQuantity.text = String(batch.quantity)
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
