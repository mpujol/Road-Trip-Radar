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
    let uid: String!
    let displayName: String!
    let email: String!
    var latitude: String!
    var longitude: String!
    
    let ref: FIRDatabaseReference?
    /*
    
     Root: UID
        Details:
            Email
            User Trips
            PhotoURL
            Location - Lat-Long
     
     
    */
    
    
    // Intitialize user through user creation
    init(uid: String, displayName: String, email: String, latitude: String = "", longitude: String = "", key: String = "") {
        self.key = key
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.ref = nil
        
    }
    
    // Initialize the user through a Snapshot
    init(snapshot: FIRDataSnapshot) {
        uid = snapshot.value!["uid"] as! String
        displayName =  snapshot.value!["displayName"] as! String
        email = snapshot.value!["email"] as! String
        latitude = snapshot.value!["latitude"] as! String
        longitude = snapshot.value!["longitude"] as! String
        ref = snapshot.ref
        
    }
    
    
    func toAnyObject() -> AnyObject {
        return [
            "uid": uid,
            "displayName": displayName,
            "email": email
            
        ]
    }
    
}

