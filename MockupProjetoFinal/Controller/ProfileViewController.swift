//
//  ProfileViewController.swift
//  MockupProjetoFinal
//
//  Created by PUCPR on 05/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class ProfileViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = UserDefaults.standard.string(forKey: "currentUserEmail")
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
    
    @IBAction func update(_ sender: Any) {
        let pass = password.text!
        let passConf = passwordConfirmation.text!
        var ref = Database.database().reference()
        
        if pass != passConf {
            Alert.display(self, "Erro", "Senha e confirmação não conferem.", "Entendi")
            return
        }
        
        let data = JSON([
            "email": email.text!,
            "password": password.text!,
        ])
        
        Auth.auth().currentUser?.updateEmail(to: email.text!, completion: { (error) in
            print(error)
            return
        })
        
        Auth.auth().currentUser?.updatePassword(to: pass, completion: { (error) in
            print(error)
            return
        })
        
        var userId = UserDefaults.standard.string(forKey: "currentUserId")
        ref.child("users/\(userId!)/email").setValue(email.text!)
        
        Alert.display(self, "Sucesso!", "Usuário atualizado com sucesso", "Ok!")
    }
}
