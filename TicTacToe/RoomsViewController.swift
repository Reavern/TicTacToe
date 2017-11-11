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
        // Do any additional setup after loading the view.
        listenData()
    
    }

    func listenData() {
        ref = Database.database().reference()
        ref.child("rooms").observe(DataEventType.value, with: { (snapshot) in
            self.Rooms.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let title = snap.childSnapshot(forPath: "title").value as! String
                    let key = snap.childSnapshot(forPath: "key").value as! String
                    let master = snap.childSnapshot(forPath: "master").value as! String
                    if (snap.childSnapshot(forPath: "player").value as? String) != nil {
                        
                    } else {
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
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
