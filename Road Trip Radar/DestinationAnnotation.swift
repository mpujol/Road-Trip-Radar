//
//  DestinationAnnotation.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 8/19/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit
import MapKit

class DestinationAnnotation: NSObject, MKAnnotation {

    // MARK: Properties
    
    //Required properties
    var coordinate: CLLocationCoordinate2D
    
    //Optional methods
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = title
    }

}
