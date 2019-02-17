//
//  MyRidesDetailViewController.swift
//  BrickHack
//
//  Created by Chris Haen on 2/16/19.
//  Copyright © 2019 Christopher Haen. All rights reserved.
//

import UIKit

class MyRidesDetailViewController: UIViewController {
    
    @IBOutlet weak var trip: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var capacity: UILabel!
    @IBOutlet weak var driverInfo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        trip.text = GlobalVariables.MVars.trip
        time.text = "@ " + GlobalVariables.MVars.time
        capacity.text = "Capacity: " + String(GlobalVariables.MVars.capacity) + "/" + String(GlobalVariables.MVars.carCapacity)
        //driverInfo.text = GlobalVariables.MVars.user + " - " + String(GlobalVariables.MVars.phone)
        
    }
    
    
}
