//
//  ViewController.swift
//  EasyBreath
//
//  Created by Charitos Charitou on 07/02/2016.
//  Copyright © 2016 Charitos Charitou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let healthManager:HealthManager = HealthManager()

    @IBAction func HealthKit(sender: AnyObject) {
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
            }
            else
            {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

