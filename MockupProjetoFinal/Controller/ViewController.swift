//
//  ViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 03/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class ViewController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(_ sender: Any) {
        loginButton.isEnabled = false
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (result, error) in
            
            guard let user = result?.user
                else {
                    print(error)
                    Alert.display(self, "Erro no Login", "Tente novamente", "Ok!")
                    return
            }
            Analytics.setUserProperty("sim", forName: "entrou")
            
            Analytics.logEvent("signed", parameters: ["nome": self.email.text!])
            
            UserDefaults.standard.set(user.email, forKey: "currentUserEmail")
            UserDefaults.standard.set(user.uid, forKey: "currentUserId")
            UserDefaults.standard.set(true, forKey: "currentUserPresent?")
            
            self.goToRootPage()
        }
        loginButton.isEnabled = true
    }
    
    @IBAction func register(_ sender: Any) {
        registerButton.isEnabled = false
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (result, error) in
            
            guard let user = result?.user
            else {
                print(error)
                return
            }
            
            let userData = ["email": self.email.text! as String]
            
            self.ref.child("users").child(user.uid).setValue(userData)
            
            Alert.display(self, "Sucesso", "Usuário cadastrado com sucesso", "Realizar Login")
        }
        
        registerButton.isEnabled = true
    }
    
    func goToRootPage(){
        performSegue(withIdentifier: "rootPage", sender: self)
    }
}

