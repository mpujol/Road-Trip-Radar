//
//  TripMapViewController.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 8/18/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit
import MapKit

class TripMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var currentTrip: Trip!
    
    
    private var spanLatitudeDelta = 0.2
    private var spanLongitudeDelta = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // start off by default in San Francisco
        
        showDestinationRegion()
        createDestinationAnnotation()
        
    }
    
    // MARK: Helper Functions
    
    func showDestinationRegion() {
        
        let currentlocationCenter = CLLocationCoordinate2D(latitude: (currentTrip.latitude as NSString).doubleValue, longitude: (currentTrip.longitude as NSString).doubleValue)
        let currentLocationSpan = MKCoordinateSpan(latitudeDelta: spanLatitudeDelta, longitudeDelta: spanLongitudeDelta)
        
        
        let destinationlocationRegion =  MKCoordinateRegion(center: currentlocationCenter, span: currentLocationSpan)
        
        self.mapView.setRegion(destinationlocationRegion, animated: true)
        
    }
    func createDestinationAnnotation() {
        //Create an Annotation
        let destinationLocattioinAnnotation = DestinationAnnotation(coordinate: CLLocationCoordinate2D(latitude: (currentTrip.latitude as NSString).doubleValue, longitude: (currentTrip.longitude as NSString).doubleValue), title: currentTrip.name, subtitle: "")
        
        self.mapView.addAnnotation(destinationLocattioinAnnotation)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
