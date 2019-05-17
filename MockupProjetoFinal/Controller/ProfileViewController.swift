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
    @IBOutlet weak var cpf: UITextField!
    @IBOutlet weak var cep: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var number: UITextField!
    var userId = UserDefaults.standard.string(forKey: "currentUserId")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = UserDefaults.standard.string(forKey: "currentUserEmail")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var ref = Database.database().reference()
        ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value == nil {
                return
            }
            let userData = JSON(value!)
            var newUser = User()
            
            let userName = userData["name"].stringValue
            let userCpf = userData["cpf"].stringValue
            let userCep = userData["cep"].stringValue
            let userAddress = userData["address"].stringValue
            let userNumber = userData["number"].stringValue
            let userType = userData["userType"].stringValue
            
            newUser.name = userName
            newUser.cpf = userCpf
            newUser.cep = userCep
            newUser.address = userAddress
            newUser.number = userNumber
            
            self.cpf.text = newUser.cpf
            self.cep.text = newUser.cep
            self.address.text = newUser.address
            self.number.text = newUser.number
        })
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
        ref.child("users/\(userId!)/cpf").setValue(cpf.text!)
        ref.child("users/\(userId!)/cep").setValue(cep.text!)
        ref.child("users/\(userId!)/number").setValue(number.text!)
        ref.child("users/\(userId!)/address").setValue(address.text!)
        
        Alert.display(self, "Sucesso!", "Usuário atualizado com sucesso", "Ok!")
    }
}
