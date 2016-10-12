//
//  DashboardTableViewController.swift
//  ContactMySensors
//
//  Created by Jack N. Archer on 11/10/2016.
//  Copyright © 2016 Jack N. Archer. All rights reserved.
//

import UIKit

/// This class refers to the dashboard that will apper first when the app launched.
/// It will display the current readings from the two sensors.
class DashboardTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    /// Indicate if the program should hide detail view, the default value should be true to initialy hide the detail view
    /// - true: hide detail view controller
    /// - false: display detail view controller
    /// idea comes from: http://nshipster.com/uisplitviewcontroller/
    var isHideDetail:Bool = true
    
    /// One part of the data source, which indicates the cunrrent color readings
    var currentColor:[ColorRecord] = []
    
    /// Another part of the data source, which indicates the current temperature readings
    var currentTemperature:[TemperatureRecord] = []
    
    /// This function is used to load or realod the data from server
    func reload(){
        // temp function for process color
        func processColor(_ data: Data!) {
            process(for: "color" , from: data)
        }
        // temp function for process temperature
        func processTemperature(from data: Data!){
            process(for: "temperature", from: data)
        }
        
        // The actually (re)load part
        LoadRemoteData.loadData(api: "colorsensor/current", successfulHandler: processColor, failHandler: nil)
        LoadRemoteData.loadData(api: "multisensor/current", successfulHandler: processTemperature, failHandler: nil)
    }
    
    /// This function is used to process the data load from our server, to a valid JSON formmat
    /// Basicaly, this function will act as a compeletion handler for the communication function(implemented in the class LoadRemoteData.swift staticly)..
    /// - Parameters:
    ///     - data: The row JSON data
    func process(for type: String, from data: Data!){
        
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
                if (type == "color"){
                    processCurrentColor(from: readings)
                } else if type == "temperature"{
                    processCurrentTemperature(from: readings)
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
    
    /// This function is used to process the content of the response JSON to a color record. Then store it into local variable
    /// - Parameters:
    ///     - readings: An array that contains only one result, which refers to the current reading
    func processCurrentColor(from readings: NSArray!){
        
        for reading in readings{
            guard
                let reading = reading as? [String:AnyObject],
                let clear = reading["clear"] as? Double,
                let red = reading["red"] as? Double,
                let green = reading["green"] as? Double,
                let blue = reading["blue"] as? Double,
                let timestamp = reading["timestamp"] as? Int
                else {
                    // TODO: handler for converting to json fails about reading
                    print("A reading fails on converting")
                    return
            }
            currentColor.append(ColorRecord(clear: clear, red: red, green: green, blue: blue, timeInterval: timestamp))
        }
        
    }
    
    /// This function is used to process the content of the response JSON to a temperature record. Then store it into local variable
    /// - Parameters:
    ///     - readings: An array that contains only one result, which refers to the current reading
    func processCurrentTemperature(from readings: NSArray!){
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
            currentTemperature.append(TemperatureRecord(thermometer: thermometer, barometer: barometer, altimeter: altimeter, timeInterval: timestamp))
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate to config split view controller
        splitViewController?.delegate = self
        
        // hide footer
        tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Set auto-adjust cell height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600
        
        // Add the refresh button
        let btnRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        self.navigationItem.rightBarButtonItems?.append(btnRefresh)
     
        // load data!
        self.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentDetail", for: indexPath)
        
        // Configure the cell...
        if indexPath.row == 0{
            cell.textLabel?.text = currentTemperature?.getDetailInString()
        } else if indexPath.row == 1{
            cell.textLabel?.text = currentColor?.getDetailInString()
        }
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // when selected a row, go to detail view
        isHideDetail = false
        performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
    
    // split view controller relevant
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return isHideDetail
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        <#code#>
    }
    
    
}
