//
//  RegisterViewController.swift
//  TicTacToe
//
//  Created by Farell on 10/11/17.
//  Copyright © 2017 Farell. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var rePassTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        if emailTF.text != "" || passTF.text != "" {
            if passTF.text == rePassTF.text {
                Auth.auth().createUser(withEmail: emailTF.text!, password: passTF.text!, completion: { (user, error) in
                        if error != nil {
                            print(error)
                        } else {
                            print("Registered")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                )
            } else {
                print("Pass != Re Pass")
            }
        } else {
            print("Email / Pass Null")
        }
    }
    
    
    @IBAction func singInButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
