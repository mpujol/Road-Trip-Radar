//
//  AppState.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 7/7/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit

class AppState: NSObject {
    		
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoUrl: NSURL?
    
}
