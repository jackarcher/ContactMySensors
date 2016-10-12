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
    var currentColor:NSMutableArray = NSMutableArray()
    
    /// Another part of the data source, which indicates the current temperature readings
    var currentTemperature:NSMutableArray = NSMutableArray()
    
    /// This function is used to load or realod the data from server
    func reload(){
        // The actually (re)load part
        LoadRemoteData.loadData(api: "colorsensor/current", for: "color", in: self.tableView, into: currentColor, failHandler: nil)
        LoadRemoteData.loadData(api: "multisensor/current", for: "temperature", in: self.tableView, into: currentTemperature, failHandler: nil)
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
        self.navigationItem.rightBarButtonItem = btnRefresh
     
        
        
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
            cell.textLabel?.text = (currentTemperature.firstObject as? DisplayableRecord)?.getDetailInString()
        } else if indexPath.row == 1{
            cell.textLabel?.text = (currentColor.firstObject as? DisplayableRecord)?.getDetailInString()
        }
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // when selected a row, go to detail view
        isHideDetail = false
        performSegue(withIdentifier: "toSensorList", sender: indexPath.row)
    }
    
    // split view controller relevant
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return isHideDetail
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSensorList"{
            let navi = segue.destination as! UINavigationController
            let target = navi.viewControllers[0] as! RecordListTableViewController
            if let sender = sender as? Int{
                if sender == 0 {
                    target.type = "temperature"
                } else if sender == 1 {
                    target.type = "color"
                }
            }
        }
    }
    
    
}
