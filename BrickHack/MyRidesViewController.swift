//
//  MyRidesViewController.swift
//  BrickHack
//
//  Created by Chris Haen on 2/16/19.
//  Copyright © 2019 Christopher Haen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MyRidesViewController: UIViewController, UITableViewDataSource {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        // Start process
        let group = DispatchGroup()
        group.enter()
        // Retreive users
        db.collection("users").document(((UserDefaults.standard.object(forKey: "username") as? String)!)).collection("hostedRides").getDocuments() { (querySnapshot, err) in
            if err != nil {
                // Error getting documents
            } else {
                // get users
                for document in querySnapshot!.documents {
                    if ((document.documentID) != "default"){
                        self.rideNumber.append(document.documentID)
                        self.trips.append((document.get("departureLocation") as! String) + " -> " + (document.get("destination") as! String))
                        self.capacity.append(document.get("spotsTaken") as! Int)
                        
                        let formatter = DateFormatter()
                        // initially set the format based on your datepicker date / server String
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatter.dateFormat = "dd MMM yyyy - HH:mm"
                        
                        if let timestamp = document.get("departureTime") as? Timestamp {
                            let date = timestamp.dateValue()
                            let dateString = formatter.string(from: date)
                            self.times.append(dateString)
                        }
                    
                        self.tableView.reloadData()
                        
                    }
                }
                // Data has finished downloading so send signal to start retrieving bios
                DispatchQueue.main.async {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            // Start process
            let group = DispatchGroup()
            group.enter()
            // Retreive users
            db.collection("users").document(((UserDefaults.standard.object(forKey: "username") as? String)!)).collection("JoinedRides").getDocuments() { (querySnapshot, err) in
                if err != nil {
                    // Error getting documents
                } else {
                    // get users
                    for document in querySnapshot!.documents {
                        if ((document.documentID) != "default"){
                            self.rideNumber.append(document.documentID)
                            self.trips.append((document.get("departureLocation") as! String) + " -> " + (document.get("destination") as! String))
                            self.capacity.append(document.get("spotsTaken") as! Int)
                            
                            let formatter = DateFormatter()
                            // initially set the format based on your datepicker date / server String
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            formatter.dateFormat = "dd MMM yyyy - HH:mm"
                            
                            if let timestamp = document.get("departureTime") as? Timestamp {
                                let date = timestamp.dateValue()
                                let dateString = formatter.string(from: date)
                                self.times.append(dateString)
                            }
                            
                            self.tableView.reloadData()
                            
                        }
                    }
                    // Data has finished downloading so send signal to start retrieving bios
                    DispatchQueue.main.async {
                        group.leave()
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
        
        // Start process
        let group = DispatchGroup()
        group.enter()
        // Retreive users
        db.collection("users").document(((UserDefaults.standard.object(forKey: "username") as? String)!)).collection("hostedRides").getDocuments() { (querySnapshot, err) in
            if err != nil {
                // Error getting documents
            } else {
                // get users
                for document in querySnapshot!.documents {
                    if ((document.documentID) != "default"){
                        self.rideNumber.append(document.documentID)
                        self.trips.append((document.get("departureLocation") as! String) + " -> " + (document.get("destination") as! String))
                        self.capacity.append(document.get("spotsTaken") as! Int)
                        
                        let formatter = DateFormatter()
                        // initially set the format based on your datepicker date / server String
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatter.dateFormat = "dd MMM yyyy - HH:mm"
                        
                        if let timestamp = document.get("departureTime") as? Timestamp {
                            let date = timestamp.dateValue()
                            let dateString = formatter.string(from: date)
                            self.times.append(dateString)
                        }
                        
                        self.tableView.reloadData()
                        
                    }
                }
                // Data has finished downloading so send signal to start retrieving bios
                DispatchQueue.main.async {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            // Start process
            let group = DispatchGroup()
            group.enter()
            // Retreive users
            db.collection("users").document(((UserDefaults.standard.object(forKey: "username") as? String)!)).collection("joinedRides").getDocuments() { (querySnapshot, err) in
                if err != nil {
                    // Error getting documents
                } else {
                    // get users
                    for document in querySnapshot!.documents {
                        if ((document.documentID) != "default"){
                            self.rideNumber.append(document.documentID)
                            self.trips.append((document.get("departureLocation") as! String) + " -> " + (document.get("destination") as! String))
                            self.capacity.append(document.get("spotsTaken") as! Int)
                            
                            let formatter = DateFormatter()
                            // initially set the format based on your datepicker date / server String
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            formatter.dateFormat = "dd MMM yyyy - HH:mm"
                            
                            if let timestamp = document.get("departureTime") as? Timestamp {
                                let date = timestamp.dateValue()
                                let dateString = formatter.string(from: date)
                                self.times.append(dateString)
                            }
                            
                            self.tableView.reloadData()
                            
                        }
                    }
                    // Data has finished downloading so send signal to start retrieving bios
                    DispatchQueue.main.async {
                        group.leave()
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
            
            //GlobalVariables.MVars.user = self.users[selected![1]]
            GlobalVariables.MVars.rideNumber = self.rideNumber[selected![1]]
            GlobalVariables.MVars.trip = self.trips[selected![1]]
            GlobalVariables.MVars.time = self.times[selected![1]]
            GlobalVariables.MVars.capacity = self.capacity[selected![1]]
            //GlobalVariables.MVars.carCapacity = self.carCapacity[selected![1]]
            //GlobalVariables.MVars.phone = self.phone[selected![1]]
            
            // DeSelect any slected rows in tableview
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

