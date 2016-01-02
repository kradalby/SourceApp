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
    
    lazy var refreshFunction: UIRefreshControl = {() -> UIRefreshControl in
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Players"
        
        tableView.registerNib(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerTableViewCell")
        
        self.refreshControl = refreshFunction
        self.tableView.addSubview(refreshControl!)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let players = self.serverInformation?.players?.numberOfPlayers {
            return players
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("PlayerTableViewCell", forIndexPath: indexPath) as! PlayerTableViewCell
        
        cell.playerNameLabel?.text = self.serverInformation?.players?.players[indexPath.row].name
        if let kills = self.serverInformation?.players?.players[indexPath.row].kills {
            cell.killsLabel.text = "\(kills)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell \(indexPath.row)!")
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.serverInformation?.players?.update({
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        })
    }
}