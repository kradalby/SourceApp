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
    
    
    var serverInformation: ServerInfo? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Information"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.serverInformation = ServerInfo(address: "193.202.115.74:27139")
        self.serverInformation?.update({
            self.hostnameLabel.text = self.serverInformation?.hostname
            self.playersLabel.text = self.serverInformation?.numberOfPlayersOfMax()
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
}
