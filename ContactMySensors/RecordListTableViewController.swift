//
//  RecordListTableViewController.swift
//  ContactMySensors
//
//  Created by Jack N. Archer on 11/10/2016.
//  Copyright © 2016 Jack N. Archer. All rights reserved.
//

import UIKit

class RecordListTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    /// Refers to the data type that this instance will have to deal with, either "temperature" or "color"
    var type:String?
    
    /// The data source of the table, which should contain all the recorods load from server, and read from the sensors.
    /// This variable will be updated through viewDidLoad() and a seperate refresh button
    var recordList:NSMutableArray = NSMutableArray()
    
    /// This function is used to trigger a load action (when first loading) or a reload action (when refresh button triggered by the user) for the recordList.
    func reloadRecords(){
        LoadRemoteData.loadData(api: "multisensor/50", for: type!, in: self.tableView, into: recordList, failHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // portrait button
        self.navigationItem.leftBarButtonItems?.append((self.splitViewController?.displayModeButtonItem)!)
        
        // add refresh button
        let btnRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadRecords))
        self.navigationItem.rightBarButtonItem = btnRefresh
        
        reloadRecords()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recordList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // config cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "temperatureRecordCell", for: indexPath)
        cell.textLabel?.text = (recordList[indexPath.row] as! DisplayableRecord).getFormattedTime()
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTemperatureDetail", sender: indexPath.row)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTemperatureDetail" {
            let target = segue.destination as! TemperatureDetailTableViewController
            let sender = sender as! Int
            target.temperatureRecord = recordList[sender] as! TemperatureRecord
        }
    }
    

}
