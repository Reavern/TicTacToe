//
//  LoginViewController.swift
//  TicTacToe
//
//  Created by Farell on 10/11/17.
//  Copyright © 2017 Farell. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import RealmSwift

var user = ""

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var rememberState: UISwitch!
    
    var userArray = List<UserModel>()
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.realm = try! Realm()
        loadEmail()
    }

    
    func loadEmail() {
        let lists = realm.objects(UserModel.self)

        if self.userArray.realm == nil, lists.count > 0 {
            for list in lists {
                self.userArray.append(list)
            }
            self.rememberState.isOn = true
            self.emailTF.text = userArray[0].email
            user = userArray[0].email
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if emailTF.text != "" || passTF.text != "" {
            Auth.auth().signIn(withEmail: emailTF.text!, password: passTF.text!, completion: { (usr, error) in
                if error != nil {
                    print(error!)
                } else {
                    user = self.emailTF.text!
                    if self.rememberState.isOn {
                        let userTemp = UserModel()
                        userTemp.email = self.emailTF.text!
                        self.userArray.removeAll()
                        self.userArray.append(userTemp)
                        print(self.userArray)
                        try! self.realm.write {
                            self.realm.deleteAll()
                            self.realm.add(self.userArray)
                        }
                    } else {
                        try! self.realm.write {
                            self.realm.deleteAll()
                        }
                    }
                    self.performSegue(withIdentifier: "mainSegue", sender: nil)
                }
            })
        } else {
            print("Email / Pass Null")
        }
    }

}
