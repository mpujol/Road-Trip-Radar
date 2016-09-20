//
//  Location.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 8/28/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Location {
    
    let key: String!
    let latitude: String!
    let longitude: String!
    let timestamp: String!
 
    let ref: FIRDatabaseReference?
    
    //Initialize the location from arbitrary data
    
    init(latitude: String, longitude: String, timestamp: String, key: String = ""){
        
        self.key = key
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.ref = nil
        
    }
    
    
    //Initialize the location from a snapshot
    init(snapshot: FIRDataSnapshot!) {
        key = snapshot.key
        latitude = snapshot.value(forKey: "latitude") as! String
        longitude = snapshot.value(forKey: "longitude") as! String
        timestamp = snapshot.value(forKey: "timestamp") as! String
        ref = snapshot.ref
    }
    
    // turn the struct into a dictionary for the JSON file
    func toAnyObject() -> Any {
        return [
            "latitude": latitude,
            "longitude": latitude,
            "timestamp": timestamp
        ]
    }
    
    
    
}
