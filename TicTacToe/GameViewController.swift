//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Farell on 11/11/17.
//  Copyright © 2017 Farell. All rights reserved.
//

import UIKit
import Firebase

class GameViewController: UIViewController {

    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(key)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

}
