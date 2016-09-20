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
    var members: [String:String]
    var totalMembers: Int {
        get {
            return self.members.count
        }
    }
    let ref: FIRDatabaseReference?
    
    // Intitialize the Trip from arbitrary data
    
    init(name: String, addedByUser: String, latitude: String, longitude: String, members: [String:String], key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.latitude = latitude
        self.longitude = longitude
        self.members = members
        self.ref = nil
    }
    
    // Initialize from a firebase snapshot
    init (snapshot: FIRDataSnapshot!) {
        key = snapshot.key
        name = snapshot.value(forKey: "name") as! String
        addedByUser = snapshot.value(forKey: "addedByUser") as! String
        latitude = snapshot.value(forKey: "latitude") as! String
        longitude = snapshot.value(forKey: "longitude") as! String
        members = snapshot.value(forKey: "members") as! Dictionary
        ref = snapshot.ref
    }
    
    // Method for converting arbitrary data to any objects
    func toAnyObject() -> Any {
        return [
        "name": name,
        "addedByUser": addedByUser,
        "latitude": latitude,
        "longitude": longitude,
        "members" : members
        ]
    }
    
}
