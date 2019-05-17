//
//  DeliverBatchInfoViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 17/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class DeliverBatchInfoViewController: UIViewController {
    var batch = Batch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(batch)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = batch.city
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
