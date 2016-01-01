//
//  DetailViewController.swift
//  Source
//
//  Created by Kristoffer Dalby on 31/12/15.
//  Copyright © 2015 Kristoffer Dalby. All rights reserved.
//


import Foundation
import UIKit

class PlayersViewController: UITableViewController {
    
    
    var serverInformation: ServerInfo? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Players"
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PlayerTableViewCell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(serverInformation?.hostname)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let players = self.serverInformation?.players?.numberOfPlayers {
            return players
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("PlayerTableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.serverInformation?.players?.players[indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell \(indexPath.row)!")
    }
}