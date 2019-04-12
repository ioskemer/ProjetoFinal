//
//  Card.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 12/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation

class Card {
    var ownerName: String
    var number: String
    var expirationDate: Date
    
    init(){
        self.ownerName = ""
        self.number = ""
        self.expirationDate = Date()
    }
    
    init(_ number: String, _ ownerName: String, _ expirationDate: Date){
        self.number = number
        self.ownerName = ownerName
        self.expirationDate = expirationDate
    }
}
