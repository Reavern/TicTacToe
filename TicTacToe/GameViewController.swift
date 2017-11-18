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

    @IBOutlet weak var turnLabel: UILabel!
    let data = [
        ["a", "b", "c"],
        ["d", "e", "f"],
        ["g", "h", "i"]
    ]
    let winValidation = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7 ,8],
        
        [0, 4, 8],
        [2, 4, 6],
        
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8]
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
            self.checkGameData()
            self.winVal()
            self.setUI()
            self.collectionView.reloadData()
        }
        
        
    }

    func setUI() {
        if Game.turn == myTurn {
            turnLabel.text = "Your Turn !"
        } else {
            turnLabel.text = "Opponent's Turn !"
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
    
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkGameData() {
        if Game.status == 2 {
            let alert = UIAlertController(title: "Game Stoped", message: "A Player Has Left The Game", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) -> Void in
                self.popVC()
            })
            self.present(alert, animated: true)
        } else {
            if Game.status == 3 {
                if myTurn == 0 {
                    let alert = UIAlertController(title: "Victory", message: "You Won The Game", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) -> Void in
                        self.popVC()
                    })
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "You Lose", message: "Opponent Has Won The Game", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) -> Void in
                        self.popVC()
                    })
                    self.present(alert, animated: true)
                }
                
            } else if Game.status == 4 {
                if myTurn == 1 {
                    let alert = UIAlertController(title: "Victory", message: "You Has Won The Game", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: { () in
                        self.popVC()
                    })
                } else {
                    let alert = UIAlertController(title: "You Lose", message: "Opponent Has Won The Game", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: { () in
                        self.popVC()
                    })
                }
            }
        }
        
    }
    
    func winVal() {
        var gameData = [Int]()
        for list in data {
            for index in 0...2 {
                gameData.append(Game.blocks[list[index]]!)
            }
        }
        print(gameData)
        for val in winValidation {
            print(val)
            if gameData[val[0]] == gameData[val[1]] && gameData[val[1]] == gameData[val[2]] {
                if gameData[val[0]] == 0 {
                    ref.child("game").child("status").setValue(3)
                } else if gameData[val[0]] == 1 {
                    ref.child("game").child("status").setValue(4)
                } else {
                    print("nay")
                }
            }
        }
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
        if Game.blocks[tempData] == 2 && Game.turn == myTurn {
            var nextTurn = 0
            if self.Game.turn == 0 {
                nextTurn = 1
            }
            ref.child("game").child("blocks").child(tempData).setValue(self.myTurn)
            ref.child("game").child("turn").child("turn").setValue(nextTurn)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        ref.child("game").child("status").setValue(2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
