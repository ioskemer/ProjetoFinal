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
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var cep: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var additional: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cpf = "09287589909"
        
        print(cpf.isCPF)
        
        let otherCpf = "065.533.309-64"
        
        print(otherCpf.isCPF)
        
        let moreOneCpf = "1234556786"
        
        print(moreOneCpf.isCPF)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        email.layer.borderWidth = 3
        email.layer.borderColor = UIColor.white.cgColor
        email.backgroundColor = UIColor.black
        email.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        email.layer.cornerRadius = 7.0
        email.layer.borderWidth = 2.0
        
        username.layer.borderWidth = 3
        username.layer.borderColor = UIColor.white.cgColor
        username.backgroundColor = UIColor.black
        username.attributedPlaceholder = NSAttributedString(string: "Nome Completo",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        username.layer.cornerRadius = 7.0
        username.layer.borderWidth = 2.0
        
        password.layer.borderWidth = 3
        password.layer.borderColor = UIColor.white.cgColor
        password.backgroundColor = UIColor.black
        password.attributedPlaceholder = NSAttributedString(string: "Senha",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        password.layer.cornerRadius = 7.0
        password.layer.borderWidth = 2.0
        
        passwordConfirmation.layer.borderWidth = 3
        passwordConfirmation.layer.borderColor = UIColor.white.cgColor
        passwordConfirmation.backgroundColor = UIColor.black
        passwordConfirmation.attributedPlaceholder = NSAttributedString(string: "Confirmação Senha",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordConfirmation.layer.cornerRadius = 7.0
        passwordConfirmation.layer.borderWidth = 2.0
        
        cpf.layer.borderWidth = 3
        cpf.layer.borderColor = UIColor.white.cgColor
        cpf.backgroundColor = UIColor.black
        cpf.attributedPlaceholder = NSAttributedString(string: "CPF",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        cpf.layer.cornerRadius = 7.0
        cpf.layer.borderWidth = 2.0
        
        cep.layer.borderWidth = 3
        cep.layer.borderColor = UIColor.white.cgColor
        cep.backgroundColor = UIColor.black
        cep.attributedPlaceholder = NSAttributedString(string: "CEP",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        city.layer.cornerRadius = 7.0
        city.layer.borderWidth = 2.0

        city.layer.cornerRadius = 7.0
        city.layer.borderWidth = 2.0
        
        city.layer.borderWidth = 3
        city.layer.borderColor = UIColor.white.cgColor
        city.backgroundColor = UIColor.black
        city.attributedPlaceholder = NSAttributedString(string: "Cidade",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        city.layer.cornerRadius = 7.0
        city.layer.borderWidth = 2.0
        
        address.layer.cornerRadius = 7.0
        address.layer.borderWidth = 2.0
        
        address.layer.cornerRadius = 7.0
        address.layer.borderWidth = 2.0
        
        address.layer.borderWidth = 3
        address.layer.borderColor = UIColor.white.cgColor
        address.backgroundColor = UIColor.black
        address.attributedPlaceholder = NSAttributedString(string: "Endereço",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        address.layer.cornerRadius = 7.0
        address.layer.borderWidth = 2.0
        
        state.layer.cornerRadius = 7.0
        state.layer.borderWidth = 2.0
        
        state.layer.cornerRadius = 7.0
        state.layer.borderWidth = 2.0
        
        state.layer.borderWidth = 3
        state.layer.borderColor = UIColor.white.cgColor
        state.backgroundColor = UIColor.black
        state.attributedPlaceholder = NSAttributedString(string: "Endereço",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        state.layer.cornerRadius = 7.0
        state.layer.borderWidth = 2.0
        
        additional.layer.borderWidth = 3
        additional.layer.borderColor = UIColor.white.cgColor
        additional.backgroundColor = UIColor.black
        additional.attributedPlaceholder = NSAttributedString(string: "Endereço",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        additional.layer.cornerRadius = 7.0
        additional.layer.borderWidth = 2.0
        
        registerButton.layer.cornerRadius = 5
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
    
    func addStyleProps(){

    }
}
