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

    var Game = GameModel()
    
    var ref: DatabaseReference!
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Game.key = key
        ref = Database.database().reference()
        listenData()
    }

    func listenData() {
        ref.child("rooms").child(key).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let snap = snapshot.value as? [String:Any] {
                let title = snap["title"] as! String
                let key = snap["key"] as! String
                let master = snap["master"] as! String
                let player = snap["player"] as! String
                
                let game = snap["game"] as! [String:Any]
                let status = game["status"] as! Int

                self.Game.status = status
                self.Game.master = master
                self.Game.player = player
                
                
            }
            print(self.Game)
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

}
