//
//  Trip.swift
//  
//
//  Created by Michael Pujol on 7/12/16.
//
//  This is the class that will instantiate a Trip in-app & from a firebase snapshot

import Foundation
import FirebaseDatabase


struct Trip {

    let key: String!
    let name: String!
    let addedByUser: String!
    let longitude: String!
    let latitude: String!
    let ref: FIRDatabaseReference?
    
    // Intitialize the Trip from arbitrary data
    
    init(name: String, addedByUser: String, latitude: String, longitude: String, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.latitude = latitude
        self.longitude = longitude
        self.ref = nil
    }
    
    // Initialize from a firebase snapshot
    init (snapshot: FIRDataSnapshot!) {
        key = snapshot.key
        name = snapshot.value!["name"] as! String
        addedByUser = snapshot.value!["addedByUser"] as! String
        latitude = snapshot.value!["latitude"] as! String
        longitude = snapshot.value!["longitude"] as! String
        ref = snapshot.ref
    }
    
    // Method for converting arbitrary data to any objects
    func toAnyObject() -> AnyObject {
        return [
        "name": name,
        "addedByUser": addedByUser,
        "latitude": latitude,
        "longitude": longitude
        ]
    }
    
}
