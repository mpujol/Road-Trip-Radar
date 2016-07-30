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
    let uid: String!
    let displayName: String!
    let email: String!
    
    
    // Intitialize user through user creation
    init(uid: String, displayName: String, email: String) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        
    }
    
    // Initialize the user through FIRUser class
    init(user: FIRUser) {
        uid = user.uid 
        displayName =  user.email!
        email = user.email!
        
    }
    
    
    func toAnyObject() -> AnyObject {
        return [
            "uid": uid,
            "displayName": displayName,
            "email": email
            
        ]
    }
    
}

