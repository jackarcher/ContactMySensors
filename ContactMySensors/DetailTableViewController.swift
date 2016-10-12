//
//  TemperatureDetailTableViewController.swift
//  ContactMySensors
//
//  Created by Jack N. Archer on 11/10/2016.
//  Copyright © 2016 Jack N. Archer. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var record: DisplayableRecord?
    var detailList:[String]?
    var type:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the data source
        detailList = record?.getDetailInArray()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // set title
        self.navigationItem.title = "\((type?.capitalized)!) detials"
        
        // hide the footer
        tableView.tableFooterView = UIView()

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailList!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = detailList![indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}
