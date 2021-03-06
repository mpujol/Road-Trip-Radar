//
//  Users.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 7/30/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct User {
    
    let key: String
    let displayName: String!
    let email: String!
    var latitude: String!
    var longitude: String!
    var lastUpdatedTimeStamp: String!
    var photoURL: String?
    
    let ref: FIRDatabaseReference?
    
    // Intitialize user through user creation
    init(key: String = "", displayName: String, email: String, latitude: String = "", longitude: String = "", lastUpdatedTimeStamp: String = "") {
        self.key = key
        self.displayName = displayName
        self.email = email
        self.latitude = latitude
        self.longitude = longitude
        self.lastUpdatedTimeStamp = lastUpdatedTimeStamp
        self.ref = nil
        
    }
    
    // Initialize the user through a Snapshot
    init(snapshot: FIRDataSnapshot!) {
        key = snapshot.key
        displayName = snapshot.value(forKey: "displayName") as! String
        email = snapshot.value(forKey: "email") as! String
        latitude = snapshot.value(forKey: "latitude") as! String
        longitude = snapshot.value(forKey: "longitude") as! String
        lastUpdatedTimeStamp = snapshot.value(forKey: "lastUpdatedTimeStamp") as! String
        photoURL = snapshot.value(forKey: "photoURL") as? String
        
        ref = snapshot.ref
        
    }
    
    
    func toAnyObject() -> Any {
        return [
            "displayName": displayName,
            "email": email,
            "latitude": latitude,
            "longitude": longitude,
            "lastUpdatedTimeStamp": lastUpdatedTimeStamp
            
        ]
    }
    
}

