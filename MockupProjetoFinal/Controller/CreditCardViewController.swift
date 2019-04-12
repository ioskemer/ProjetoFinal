//
//  CreditCardViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 10/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class CreditCardViewController: UIViewController {
    var isNew = "true"
    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var cardOwnerName: UITextField!
    @IBOutlet weak var cardExpirationDate: UIDatePicker!
    @IBOutlet weak var cardCVC: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Novo"
        var buttonText = "Salvar"
        
        if isNew == "false"{
            self.navigationItem.title = "Editar"
            buttonText = "Atualizar"
        }
        
        let buttonAdd = UIBarButtonItem(title: buttonText, style: .plain, target: self, action: #selector(self.saveCredtiCard))
        
        self.navigationItem.rightBarButtonItems = [buttonAdd]
        
        // Do any additional setup after loading the view.
    }
    
    @objc func saveCredtiCard(){
        let number = cardNumber.text
        let ownerName = cardOwnerName.text
        let expirationDate = cardExpirationDate.date
        let cvc = cardCVC
        
        let newCard = Card(number!, ownerName!, expirationDate)
        
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
