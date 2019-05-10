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
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        email.layer.borderWidth = 3
        email.layer.borderColor = UIColor.white.cgColor
        email.backgroundColor = UIColor.black
        email.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        email.layer.cornerRadius = 7.0
        email.layer.borderWidth = 2.0
        
        password.layer.cornerRadius = 7.0
        password.layer.borderWidth = 2.0
        password.layer.borderColor = UIColor.white.cgColor
        password.backgroundColor = UIColor.black
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        loginButton.layer.cornerRadius = 5
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func login(_ sender: Any) {
        loginButton.isEnabled = false
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (result, error) in
            
            guard let user = result?.user
                else {
                    print(error)
                    Alert.display(self, "Erro no Login", "Usuário ou Senha incorretos", "Ok!")
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

    }
    
    func goToRootPage(){
        let userId = UserDefaults.standard.string(forKey: "currentUserId")

        ref = Database.database().reference(); ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value == nil {
                return
            }
            let userData = JSON(value!)
            
            let userType = userData["userType"].stringValue
  
            if userType == "admin" {
                self.performSegue(withIdentifier: "adminRootPage", sender: self)
            } else {
                self.performSegue(withIdentifier: "rootPage", sender: self)
            }
        })
    }
}

