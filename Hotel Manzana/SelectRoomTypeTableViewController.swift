//
//  SelectRoomTypeTableViewController.swift
//  Hotel Manzana
//
//  Created by Georgy Dyagilev on 21/10/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit

class SelectRoomTypeTableViewController: UITableViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var selectedRoomType: RoomType?
    var allRoomType: [RoomType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allRoomType = loadRooms()
    }

    // MARK: - Navigation
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRoomType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")!
        
        cell.textLabel?.text = allRoomType[indexPath.row].name
        cell.detailTextLabel?.text = "$ \(allRoomType[indexPath.row].price)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindToAddRegistration" {
            if let indexPath = tableView.indexPathForSelectedRow {
                selectedRoomType = allRoomType[indexPath.row]
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
