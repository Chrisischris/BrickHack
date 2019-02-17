//
//  GlobalVariables.swift
//  BrickHack
//
//  Created by Chris Haen on 2/16/19.
//  Copyright © 2019 Christopher Haen. All rights reserved.
//

import Foundation

// Class to store variables shared among classes
class GlobalVariables {
    
    struct Vars{
        static var user = String()
        static var rideNumber = String()
        static var trip = String()
        static var time = String()
        static var capacity = Int()
        static var carCapacity = Int()
        static var phone = Int()
        static var departure = String()
        static var destination = String()
        static var date = Date()
    }
    
    struct MVars{
        static var user = String()
        static var rideNumber = String()
        static var trip = String()
        static var time = String()
        static var capacity = Int()
        static var carCapacity = Int()
        static var phone = Int()
    }
    
}
