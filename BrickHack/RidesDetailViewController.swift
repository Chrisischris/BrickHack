//
//  RidesDetailViewController.swift
//  BrickHack
//
//  Created by Chris Haen on 2/16/19.
//  Copyright © 2019 Christopher Haen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class RidesDetailViewController: UIViewController {
    
    
    @IBOutlet weak var trip: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var capacity: UILabel!
    @IBOutlet weak var driverInfo: UILabel!
    @IBOutlet weak var rideRequest: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        trip.text = GlobalVariables.Vars.trip
        time.text = "@ " + GlobalVariables.Vars.time
        capacity.text = "Capacity: " + String(GlobalVariables.Vars.capacity) + "/" + String(GlobalVariables.Vars.carCapacity)
        driverInfo.text = GlobalVariables.Vars.user + " - " + String(GlobalVariables.Vars.phone)
        
    }
    
    @IBAction func requested(_ sender: Any) {
        GlobalVariables.Vars.capacity += 1
        capacity.text = "Capacity: " + String(GlobalVariables.Vars.capacity) + "/" + String(GlobalVariables.Vars.carCapacity)
        Firestore.firestore().collection("users").document(GlobalVariables.Vars.user).collection("hostedRides").document(GlobalVariables.Vars.rideNumber).updateData([
            "spotsTaken" : GlobalVariables.Vars.capacity
            ]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
        
        Firestore.firestore().collection("users").document((UserDefaults.standard.object(forKey: "username") as? String)!).collection("joinedRides").document(GlobalVariables.Vars.rideNumber).setData([
                "departureLocation" : GlobalVariables.Vars.departure,
                "departureTime" : GlobalVariables.Vars.date,
                "destination"  : GlobalVariables.Vars.destination,
                "spotsTaken" : GlobalVariables.Vars.capacity
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID:")
                }
            }
        
        rideRequest.setTitle("Joined!", for: .normal)
        
    }
    
}
