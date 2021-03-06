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
    
    class func createViewAnnotationForMapView(_ mapView: MKMapView , annotation: MKAnnotation) -> MKPinAnnotationView {
        
        //try to dequeue an existing pin view first
        var returnedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(DestinationAnnotation)) as? MKPinAnnotationView
        
        //if there is no existing pin view create a new one
        if returnedAnnotationView == nil {
            returnedAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(DestinationAnnotation))
        
            returnedAnnotationView!.pinTintColor = UIColor.purple
            returnedAnnotationView!.animatesDrop = true
            returnedAnnotationView!.canShowCallout = true
            
        
        }
        
        return returnedAnnotationView!
        
    }
    

}
