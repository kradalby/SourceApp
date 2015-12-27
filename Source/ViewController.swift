//
//  ViewController.swift
//  Source
//
//  Created by Kristoffer Dalby on 23/12/15.
//  Copyright © 2015 Kristoffer Dalby. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var servers: [String] = ["81.166.125.20:21300", "81.166.125.12:21600", "81.166.125.10:22050", "81.166.125.45:20150", "193.202.115.82:27117", "193.202.115.74:27125", "193.202.115.82:27119", "193.202.115.74:27137"]
    var serverInformationObjects: [ServerInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let nib = UINib(nibName: "ServerTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "serverCell")
        
        for server in servers {
            let serverInfo = ServerInfo(address: server)
            self.serverInformationObjects.append(serverInfo)
            serverInfo.update({
                self.tableView?.reloadData()
            })
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serverInformationObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ServerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("serverCell", forIndexPath: indexPath) as! ServerTableViewCell

        let serverInfo = self.serverInformationObjects[indexPath.row]
        cell.hostnameLabel.text = serverInfo.hostname
        cell.addressLabel.text = serverInfo.address
        cell.playersLabel.text = "\(serverInfo.maxPlayers)/\(serverInfo.maxPlayers)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell \(indexPath.row)!")
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

