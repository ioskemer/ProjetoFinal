//
//  Batch.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 15/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation
import Firebase

class Batch {
    var id: Int
    var title: String
    var description: String
    var quantity: Int
    var availableQuantity: Int
    var price: Float
    
    init(){
        self.id = 0
        self.title = ""
        self.description = ""
        self.availableQuantity = 0
        self.quantity = 0
        self.price = 0.0
    }
    
    func updateAvailableQuantity(_ db: Database, _ qtd: Int){
        let ref = db.reference()
        
        ref.child("batches").child(String(self.id)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let oldAvailableQuantity = value?["availableQuantity"] as? Int ?? 0
            let newAvailableQuantity = oldAvailableQuantity - qtd
            
            ref.child("batches/\(String(self.id))/availableQuantity").setValue(newAvailableQuantity)
        })
    }
}
