//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Farell on 11/11/17.
//  Copyright © 2017 Farell. All rights reserved.
//

import UIKit
import Firebase

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let data = [
        ["a", "b", "c"],
        ["d", "e", "f"],
        ["g", "h", "i"]
    ]
    var myTurn = 0
    var Game = GameModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var ref: DatabaseReference!
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Game.key = key
        ref = Database.database().reference()
        ref = ref.child("rooms").child(key)
        
        listenData {
            self.myTurn = self.getTurn()
            self.collectionView.reloadData()
        }
        
        
    }

    func getTurn() -> Int {
        var turn = 0
        if Game.master == user {
            turn = Game.mTurn
        } else {
            turn = Game.pTurn
        }
        return turn
    }
    
    func listenData(callback: @escaping ()->()) {
        ref.observe(.value, with: { (snapshot) in
            if let snap = snapshot.value as? [String:Any] {
                let game = snap["game"] as! [String:Any]
                let turn = game["turn"] as! [String:Any]
                
                self.Game.title = snap["title"] as! String
                self.Game.master = snap["master"] as! String
                self.Game.player = snap["player"] as! String
                self.Game.status = game["status"] as! Int
                self.Game.blocks = game["blocks"] as! [String : Int]
                self.Game.turn = turn["turn"] as! Int
                self.Game.pTurn = turn["pTurn"] as! Int
                self.Game.mTurn = turn["mTurn"] as! Int
                
            }
            callback()
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GameCell
        
        let pos = data[indexPath.section][indexPath.row]
        cell.cellView.backgroundColor = cellData(pos: pos)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tempData = self.data[indexPath.section][indexPath.row]
        if Game.blocks[tempData] == 2 {
            ref.child("game").child("blocks").child(tempData).setValue(self.myTurn) { (err, ref) in
                print("Tapped")
                // After Tapped
            }
        }
    }
    
    func cellData(pos: String) -> UIColor {
        var color = UIColor.green
        if Game.blocks[pos] == 0 {
            color = UIColor.red
        } else if Game.blocks[pos]  == 1 {
            color = UIColor.blue
        }
        return color
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ref.child("game").child("status").setValue(2)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
