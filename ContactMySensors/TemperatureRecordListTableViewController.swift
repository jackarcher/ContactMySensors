//
//  RecordListTableViewController.swift
//  ContactMySensors
//
//  Created by Jack N. Archer on 11/10/2016.
//  Copyright © 2016 Jack N. Archer. All rights reserved.
//

import UIKit

class TemperatureRecordListTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    /// The data source of the table, which should contain all the recorods load from server, and read from the sensors.
    /// This variable will be updated through viewDidLoad() and a seperate refresh button
    var temperatureRecordList:[TemperatureRecord] = []
    
    /// This function is used to process the JSON data load from our server, to make them into the recordList.
    /// Basicaly, this function will act as a compeletion handler for the communication function(implemented in the class LoadRemoteData.swift staticly)..
    /// - Parameters:
    ///     - data: The row JSON data
    func processRecords(from data: Data!){
        do {
            guard
                let responsJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject],
                // process the status data first.
                let status = responsJSON["status"] as? Int,
                let msg = responsJSON["msg"] as? String,
                let readings = responsJSON["sensorReadings"] as? NSArray
                else {
                    // TODO: handler for converting to json fails about response head
                    print("A response fails on converting")
                    return
            }
            if status == 0 || status == 1{
                // got readings
                for reading in readings{
                    guard
                        let reading = reading as? [String:AnyObject],
                        let thermometer = reading["thermometer"] as? Float,
                        let barometer = reading["barometer"] as? Float,
                        let altimeter = reading["altimeter"] as? Float,
                        let timestamp = reading["timestamp"] as? Int
                        else {
                            // TODO: handler for converting to json fails about reading
                            print("A reading fails on converting")
                            return
                    }
                    let temperatureRecord = TemperatureRecord(thermometer: thermometer, barometer: barometer, altimeter: altimeter, timeInterval: timestamp)
                    temperatureRecordList.append(temperatureRecord)
                }
            } else {
                // no readings available
                print("Error:")
                print("Code: \(status)")
                print("Detail: \(msg)")
            }
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    /// This function is used to trigger a load action (when first loading) or a reload action (when refresh button triggered by the user) for the recordList.
    func reloadRecords(){
        LoadRemoteData.loadData(api: "multisensor/50", successfulHandler: processRecords, failHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // portrait button
        self.navigationItem.leftBarButtonItems?.append((self.splitViewController?.displayModeButtonItem)!)
        
        // add refresh button
        let btnRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadRecords))
        self.navigationItem.rightBarButtonItems?.append(btnRefresh)
        
        reloadRecords()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return temperatureRecordList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // config cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "temperatureRecordCell", for: indexPath)
        cell.textLabel?.text = temperatureRecordList[indexPath.row].getFormattedTime()
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
            target.temperatureRecord = temperatureRecordList[sender]
        }
    }
    

}
