//
//  CreateTripViewController.swift
//  BrickHack
//
//  Created by Chris Haen on 2/16/19.
//  Copyright © 2019 Christopher Haen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CreateTripViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var departureLocation: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var create: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createTapped(_ sender: Any) {
        Firestore.firestore().collection("users").document((UserDefaults.standard.object(forKey: "username") as? String)!).collection("hostedRides").document().setData([
            "departureLocation" : departureLocation.text ?? "None",
            "departureTime" : time.date,
            "destination"  : destination.text ?? "None",
            "spotsTaken" : 1
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID:")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard when return is hit
        self.view.endEditing(true)
        return false
    }
}
