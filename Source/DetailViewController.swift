//
//  DetailViewController.swift
//  Source
//
//  Created by Kristoffer Dalby on 31/12/15.
//  Copyright © 2015 Kristoffer Dalby. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableViewInformation: UITableView!
    @IBOutlet var tableViewPlayers: UITableView!
    
    var serverInformation: ServerInfo? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Information"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(serverInformation?.hostname)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableViewInformation {
            return 5
        } else {
            return 10
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView === self.tableViewInformation {
            
        } else if tableView === self.tableViewPlayers {
            
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView === self.tableViewInformation {
            
        } else if tableView === self.tableViewPlayers {
            
        }
        print("You selected cell \(indexPath.row)!")
    }
}