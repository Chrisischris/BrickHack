//
//  RidesViewController.swift
//  BrickHack
//
//  Created by Chris Haen on 2/16/19.
//  Copyright © 2019 Christopher Haen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class RidesViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Declare string arrays for table
    var users = [String]()
    var names = [String]()
    var trips = [String]()
    var times = [String]()
    var rideNumber = [String]()
    var capacity = [Int]()
    var carCapacity = [Int]()
    var phone = [Int]()
    var departure = [String]()
    var destination = [String]()
    var dates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let defaults = UserDefaults.standard
        let showSignIn = defaults.bool(forKey:"showSignIn")
        if showSignIn == true{
            let alert = UIAlertController(title: "Please fill out your Info", message: "", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "Username"
            }
            alert.addTextField { (textField) in
                textField.text = "Phone Number"
            }
            alert.addTextField { (textField) in
                textField.text = "Car Capacity (0 if no car)"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
                let username = alert!.textFields![0].text
                let phoneNumber = alert!.textFields![1].text
                let carCapacity = alert!.textFields![2].text
                
                if (username != "Username" && phoneNumber != "Phone Number" && carCapacity != "Car Capacity (0 if no car)"){
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(phoneNumber, forKey: "phone")
                    UserDefaults.standard.set(carCapacity, forKey: "carCapacity")
                    
                    Firestore.firestore().collection("users").document(username!).setData([
                        "carCapacity" : Int(carCapacity ?? "0") ?? 0,
                        "phoneNumber" : Int(phoneNumber ?? "0") ?? 0,
                        "hosting" : 0
                    ]){ err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added with ID: \(String(describing: username))")
                            }
                    }
                    
                    Firestore.firestore().collection("users").document(username!).collection("hostedRides").document("default").setData(["default" : "default"])
                    Firestore.firestore().collection("users").document(username!).collection("joinedRides").document("default").setData(["default" : "default"])
                    Firestore.firestore().collection("users").document(username!).collection("requestedRides").document("default").setData(["default" : "default"])
                    
                }else{
                    self.present(alert!, animated: true, completion: nil)
                }
                
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
            // Set show sign in to flase so it is never shown again
            let defaults = UserDefaults.standard
            defaults.setValue(false, forKey:"showSignIn")
            defaults.synchronize()
        }
        
        // Table View refresh control
        tableView.refreshControl = UIRefreshControl ()
        tableView.refreshControl?.addTarget(self, action: #selector(RidesViewController.refresh(_:)), for: UIControl.Event.valueChanged)
        // Hide Extra Table Lines
        tableView.tableFooterView = UIView()
        // Firebase beta database
        let db = Firestore.firestore()
        // Reset arrays
        self.users = [String]()
        self.names = [String]()
        self.trips = [String]()
        self.times = [String]()
        self.rideNumber = [String]()
        self.capacity = [Int]()
        self.carCapacity = [Int]()
        self.phone = [Int]()
        self.departure = [String]()
        self.destination = [String]()
        self.dates = [Date]()
        
        // Start process
        let group = DispatchGroup()
        group.enter()
        // Retreive users
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if err != nil {
                // Error getting documents
            } else {
                // get users
                for document in querySnapshot!.documents {
                    if ((document.get("hosting") as! Int) == 1){
                        self.users.append(document.documentID)
                        self.phone.append(document.get("phoneNumber") as! Int)
                        self.carCapacity.append(document.get("carCapacity") as! Int)
                    }
                }
                // Data has finished downloading so send signal to start retrieving bios
                DispatchQueue.main.async {
                    group.leave()
                }
            }
        }
        
        // When popular documents are done retrieve bios from accounts collection
        group.notify(queue: .main) {
            // Retreive rides
            for user in self.users{
                db.collection("users").document(user).collection("hostedRides").getDocuments() { (querySnapshot, err) in
                    if err != nil {
                        // Error getting documents
                    } else {
                        // For each document in users check if hosting a ride
                        for document in querySnapshot!.documents {
                            if (document.documentID != "default"){
                                self.rideNumber.append(document.documentID)
                                self.trips.append((document.get("departureLocation") as! String) + " -> " + (document.get("destination") as! String))
                                self.names.append(user)
                                self.capacity.append(document.get("spotsTaken") as! Int)
                                
                                self.departure.append((document.get("departureLocation") as! String))
                                self.destination.append((document.get("destination") as! String))
                                
                                let formatter = DateFormatter()
                                // initially set the format based on your datepicker date / server String
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                formatter.dateFormat = "dd MMM yyyy - HH:mm"
                                
                                let date = document.get("departureTime") as! Timestamp
                                self.dates.append(date.dateValue())
                                
                                if let timestamp = document.get("departureTime") as? Timestamp {
                                    let date = timestamp.dateValue()
                                    let dateString = formatter.string(from: date)
                                    self.times.append(dateString)
                                }
                            }
                        }
                        
                        if((self.names.count == self.trips.count) && (self.trips.count == self.times.count)){
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    @objc func refresh (_ sender: Any) {
        // Firebase beta database
        let db = Firestore.firestore()
        // Reset arrays
        self.users = [String]()
        self.names = [String]()
        self.trips = [String]()
        self.times = [String]()
        self.rideNumber = [String]()
        self.capacity = [Int]()
        self.carCapacity = [Int]()
        self.phone = [Int]()
        self.departure = [String]()
        self.destination = [String]()
        self.dates = [Date]()
        
        // Start process
        let group = DispatchGroup()
        group.enter()
        // Retreive users
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if err != nil {
                // Error getting documents
            } else {
                // get users
                for document in querySnapshot!.documents {
                    if ((document.get("hosting") as! Int) == 1){
                        self.users.append(document.documentID)
                        self.phone.append(document.get("phoneNumber") as! Int)
                        self.carCapacity.append(document.get("carCapacity") as! Int)
                    }
                }
                // Data has finished downloading so send signal to start retrieving bios
                DispatchQueue.main.async {
                    group.leave()
                }
            }
        }
        
        // When popular documents are done retrieve bios from accounts collection
        group.notify(queue: .main) {
            // Retreive rides
            for user in self.users{
                db.collection("users").document(user).collection("hostedRides").getDocuments() { (querySnapshot, err) in
                    if err != nil {
                        // Error getting documents
                    } else {
                        // For each document in users check if hosting a ride
                        for document in querySnapshot!.documents {
                            if (document.documentID != "default"){
                                self.rideNumber.append(document.documentID)
                                self.trips.append((document.get("departureLocation") as! String) + " -> " + (document.get("destination") as! String))
                                self.names.append(user)
                                self.capacity.append(document.get("spotsTaken") as! Int)
                                
                                self.departure.append((document.get("departureLocation") as! String))
                                self.destination.append((document.get("destination") as! String))
                                
                                let formatter = DateFormatter()
                                // initially set the format based on your datepicker date / server String
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                formatter.dateFormat = "dd MMM yyyy - HH:mm"
                                
                                if let timestamp = document.get("departureTime") as? Timestamp {
                                    let date = timestamp.dateValue()
                                    let dateString = formatter.string(from: date)
                                    self.times.append(dateString)
                                }
                            }
                        }
                        
                        if((self.names.count == self.trips.count) && (self.trips.count == self.times.count)){
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        // Update the UI
        self.tableView.refreshControl?.endRefreshing()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.tableView.reloadData()
    }
    
    // Number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    // Set data for each table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell “PlainCell”
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        // Fill the textLabel with the account name
        cell.textLabel?.text = trips[indexPath.row]
        // Fill the details line with bio
        cell.detailTextLabel?.text = times[indexPath.row]
        
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            // Get current row selected in table
            var selected = self.tableView.indexPathForSelectedRow

            GlobalVariables.Vars.user = self.users[selected![1]]
            GlobalVariables.Vars.rideNumber = self.rideNumber[selected![1]]
            GlobalVariables.Vars.trip = self.trips[selected![1]]
            GlobalVariables.Vars.time = self.times[selected![1]]
            GlobalVariables.Vars.capacity = self.capacity[selected![1]]
            GlobalVariables.Vars.carCapacity = self.carCapacity[selected![1]]
            GlobalVariables.Vars.phone = self.phone[selected![1]]
            GlobalVariables.Vars.departure = self.departure[selected![1]]
            GlobalVariables.Vars.destination = self.destination[selected![1]]
            GlobalVariables.Vars.date = self.dates[selected![1]]
            
            // DeSelect any slected rows in tableview
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}
