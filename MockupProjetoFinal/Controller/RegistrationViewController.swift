//
//  RegistrationViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 26/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrationViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var cpf: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func register(_ sender: Any) {
        registerButton.isEnabled = false
        if password != passwordConfirmation {
            return
        }
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (result, error) in
            
            guard let user = result?.user
                else {
                    print(error)
                    return
            }
            let userEmail = user.email!
            let userData = ["email": userEmail]
            
            //self.ref.child("users").child(user.uid).setValue(userData)
            
            Alert.display(self, "Sucesso", "Usuário cadastrado com sucesso", "Realizar Login")
        }
        
        registerButton.isEnabled = true
    }
}
