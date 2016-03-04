//
//  ViewController.swift
//  EasyBreathe Pascal
//
//  Created by Pascal Loose on 27/02/2016.
//  Copyright © 2016 Pascal Loose. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {
    
    var receivedArray: [String] = []
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    @IBOutlet var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureWCSession()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureWCSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureWCSession() {
        session?.delegate = self;
        session?.activateSession()
    }
    
}

extension ViewController: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        self.receivedArray = message["key"]! as! Array
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
        print(receivedArray)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return receivedArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = receivedArray[indexPath.row]
        return cell
    }
    
}
