//
//  ViewController.swift
//  Source
//
//  Created by Kristoffer Dalby on 23/12/15.
//  Copyright © 2015 Kristoffer Dalby. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())

    var servers: [NSManagedObject] = []
    var serverInformationObjects: [ServerInfo] = []

    @IBOutlet var tableView: UITableView!

    @IBAction func addServer(sender: AnyObject) {
        let alert = UIAlertController(title: "New Server", message: nil, preferredStyle: .Alert)

        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {
            (action: UIAlertAction!) -> Void in

            let textFieldAddress = alert.textFields![0] as UITextField
            let textFieldPort = alert.textFields![1] as UITextField

            if let address = textFieldAddress.text, let port = Int(textFieldPort.text!) {
                self.saveServer(address, port: port)
                self.addServerInformationObject("\(address):\(port)")

            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) -> Void in })

        alert.addTextFieldWithConfigurationHandler({
            (textField: UITextField) -> Void in
            textField.placeholder = "Address"
        })

        alert.addTextFieldWithConfigurationHandler({
            (textField: UITextField) -> Void in
            textField.placeholder = "Port"
        })

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        presentViewController(alert, animated: true, completion: nil)

    }

    lazy var refreshControl: UIRefreshControl = {() -> UIRefreshControl in
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Servers"

        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.registerNib(UINib(nibName: "ServerTableViewCell", bundle: nil), forCellReuseIdentifier: "ServerTableViewCell")

        self.tableView.addSubview(self.refreshControl)


        // Load the servers from the database and query the API
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Server")

        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            servers = results as! [NSManagedObject]

            for server in servers {
                let address = server.valueForKey("address") as! String
                let port = server.valueForKey("port") as! Int
                self.addServerInformationObject("\(address):\(port)")
            }
        } catch {
            print("Could not fetch \(error)")
        }

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueInformationViewController" {
            if let destination = segue.destinationViewController as? InformationViewController {
                if let index = self.tableView.indexPathForSelectedRow?.row {
                    destination.serverInformation = self.serverInformationObjects[index]
                }
            }
        }
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serverInformationObjects.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ServerTableViewCell", forIndexPath: indexPath) as! ServerTableViewCell

        let serverInfo = self.serverInformationObjects[indexPath.row]
        cell.hostnameLabel.text = serverInfo.hostname
        cell.addressLabel.text = serverInfo.address
        cell.playersLabel.text = serverInfo.numberOfPlayersOfMax()

        if serverInfo.error {
            cell.backgroundColor = UIColor.redColor()
        }

        return cell
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            serverInformationObjects.removeAtIndex(indexPath.row)

            let serverToDelete = servers[indexPath.row]
            self.deleteServer(serverToDelete)


            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)

            self.tableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.performSegueWithIdentifier("SegueInformationViewController", sender: nil)
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        var counter = 0
        for server in serverInformationObjects {
            server.update({
                self.tableView.reloadData()
                counter++
                if counter == self.serverInformationObjects.count {
                    refreshControl.endRefreshing()
                }
            })
        }
    }

    func addServerInformationObject(address: String) {
        let serverInfo = ServerInfo(address: address)
        self.serverInformationObjects.append(serverInfo)
        serverInfo.update({
            self.tableView?.reloadData()
        })
    }

    func saveServer(address: String, port: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedContext = appDelegate.managedObjectContext

        let entity = NSEntityDescription.entityForName("Server", inManagedObjectContext: managedContext)

        let server = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)

        server.setValue(address, forKey: "address")
        server.setValue(port, forKey: "port")

        do {
            try managedContext.save()
        } catch {
            print("Could not save \(error)")
        }
    }

    func deleteServer(server: NSManagedObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedContext = appDelegate.managedObjectContext

        managedContext.deleteObject(server)
        do {
            try managedContext.save()
        } catch {
            print("Could not save \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

