//
//  RoomsViewController.swift
//  TicTacToe
//
//  Created by Farell on 11/11/17.
//  Copyright © 2017 Farell. All rights reserved.
//

import UIKit
import Firebase

class RoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var Rooms = [RoomsModel]()
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        listenData()
    }

    func listenData() {
        ref.child("rooms").observe(DataEventType.value, with: { (snapshot) in
            self.Rooms.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let title = snap.childSnapshot(forPath: "title").value as! String
                    let key = snap.childSnapshot(forPath: "key").value as! String
                    let master = snap.childSnapshot(forPath: "master").value as! String
                    
                    let game = snap.childSnapshot(forPath: "game")
                    let status = game.childSnapshot(forPath: "status").value as! Int
                    
                    if (status == 0) {
                        let RoomsTemp = RoomsModel()
                        RoomsTemp.title = title
                        RoomsTemp.key = key
                        RoomsTemp.master = master
                        
                        self.Rooms.append(RoomsTemp)
                    }
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Create New Room", message: "Enter a Text", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = "Default Room"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let title = alert?.textFields![0].text
            self.addRoom(title: title!)
        }))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func addRoom(title: String) {
        let key = ref.childByAutoId().key
        let mTurn = Int(arc4random_uniform(2))
        var pTurn = 1
        if mTurn == 1 {
            pTurn = 0
        }
        
        let items = [
            "key": key,
            "master": user,
            "player": "",
            "title": title,
            "game": [
                "turn": [
                    "master": mTurn,
                    "player": pTurn
                ],
                "blocks": [
                    "a": 2,
                    "b": 2,
                    "c": 2,
                    "d": 2,
                    "e": 2,
                    "f": 2,
                    "g": 2,
                    "h": 2,
                    "i": 2
                ],
                "status": 0
            ]
        ] as [String : Any]
        ref.child("rooms").child(key).setValue(items) { (error, ref) in
            self.performSegue(withIdentifier: "gameSegue", sender: key)
            
        }
    }
    
    func enterRoom(key: String, callback: @escaping ()->()) {
        let status = ref.child("rooms").child(key).child("game").child("status")
        status.setValue(1) { (error, ref) in
            if (error == nil) {
                callback()
            }
            else {
                print(error?.localizedDescription)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoomCell
        cell.titleLabel.text = Rooms[indexPath.row].title
        cell.masterLabel.text = Rooms[indexPath.row].master
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = Rooms[indexPath.row].key
        enterRoom(key: key!, callback: {
            self.performSegue(withIdentifier: "gameSegue", sender: key)
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! GameViewController
        next.key = sender as! String
    }
    

}
