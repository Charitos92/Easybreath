//
//  InterfaceController.swift
//  Accelerometer WatchKit Extension
//
//  Created by Pascal Loose on 17/02/2016.
//  Copyright © 2016 Pascal Loose. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    let session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    @IBOutlet weak var labelX: WKInterfaceLabel!
    @IBOutlet weak var labelY: WKInterfaceLabel!
    @IBOutlet weak var labelZ: WKInterfaceLabel!
    @IBOutlet weak var labelT: WKInterfaceLabel!
    
    let motionManager = CMMotionManager()
    
    var timer = NSTimer()
    var accArray: [String] = []
    
    var xString:String = ""
    var yString:String = ""
    var zString:String = ""
    
    var testArray: [String] = ["1", "2", "3"]
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        motionManager.accelerometerUpdateInterval = 0.1
    }
    
    override func willActivate() {
        super.willActivate()
        
        if motionManager.accelerometerAvailable {
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: NSError?) -> Void in
                self.xString = String(format: "%.2f", data!.acceleration.x)
                self.yString = String(format: "%.2f", data!.acceleration.y)
                self.zString = String(format: "%.2f", data!.acceleration.z)
            }
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
        }
            else {
                labelX.setText("not available")
                labelY.setText("not available")
                labelZ.setText("not available")
            }
    }
    
    func update() {
                /* self.accArray.append(NSDate().formattedISO8601)
                self.accArray.append(xString)
                self.accArray.append(yString)
                self.accArray.append(zString) */
                
                self.accArray.insert(NSDate().formattedISO8601, atIndex: 0)
                self.accArray.insert(xString, atIndex: 1)
                self.accArray.insert(yString, atIndex: 2)
                self.accArray.insert(zString, atIndex: 3)
                
                self.labelT.setText(self.accArray[0])
                self.labelX.setText(self.accArray[1])
                self.labelY.setText(self.accArray[2])
                self.labelZ.setText(self.accArray[3])
    }
    
    @IBAction func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    @IBAction func stop() {
        timer.invalidate()
        
        self.labelT.setText(self.accArray[0])
        self.labelX.setText(self.accArray[1])
        self.labelY.setText(self.accArray[2])
        self.labelZ.setText(self.accArray[3])
    }
    
    @IBAction func sendButton() {
        if(WCSession.isSupported()) {
            let message = ["key":accArray]
            // The paired iPhone has to be connected via Bluetooth.
            if let session = session where session.reachable {
                session.sendMessage(message,
                    replyHandler: { replyData in
                        // handle reply from iPhone app here
                        print(replyData)
                    }, errorHandler: { error in
                        // catch any errors here
                        print(error)
                })
            } else {
                // when the iPhone is not connected via Bluetooth
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        // motionManager.stopAccelerometerUpdates()
    }

}

extension NSDate {
    struct Date {
        static let formatterISO8601: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            formatter.dateFormat = "mm:ss.SSSX'T'yyyy-MM-dd"
            return formatter
        }()
    }
    var formattedISO8601: String { return Date.formatterISO8601.stringFromDate(self) }
}
