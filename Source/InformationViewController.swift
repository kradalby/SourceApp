//
//  DetailViewController.swift
//  Source
//
//  Created by Kristoffer Dalby on 31/12/15.
//  Copyright © 2015 Kristoffer Dalby. All rights reserved.
//

import Foundation
import UIKit

class InformationViewController: UITableViewController {
    
    @IBOutlet weak var hostnameLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var secureLabel: UILabel!
    @IBOutlet weak var osLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    
    
    var serverInformation: ServerInfo? = nil;
    
    lazy var refreshFunction: UIRefreshControl = {() -> UIRefreshControl in
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Information"
        
        self.refreshControl = refreshFunction
        self.tableView.addSubview(refreshControl!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.serverInformation?.update({
            
            self.hostnameLabel.text = self.serverInformation?.hostname
            self.playersLabel.text = self.serverInformation?.numberOfPlayersOfMax()
            self.mapLabel.text = self.serverInformation?.map
            self.gameLabel.text = self.serverInformation?.gameDescription
            
            if let secure = self.serverInformation?.secure {
                if secure {
                    self.secureLabel.text = "Yes"
                } else {
                    self.secureLabel.text = "No"
                }
            }
            
            if let os = self.serverInformation?.os {
                if os == "l" {
                    self.osLabel.text = "Linux"
                } else {
                    self.osLabel.text = "Windows"
                }
            }
            
            self.tableView.reloadData()
        })
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell \(indexPath.row)!")
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SeguePlayersViewController" {
            if let destination = segue.destinationViewController as? PlayersViewController {
                print(destination)
                destination.serverInformation = self.serverInformation
            }
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.serverInformation?.update({
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        })
    }
}
