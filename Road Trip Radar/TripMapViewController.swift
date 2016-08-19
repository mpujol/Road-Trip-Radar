//
//  TripMapViewController.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 8/18/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit
import MapKit

class TripMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var currentTrip: Trip!
    
    private var spanLatitudeDelta = 0.2
    private var spanLongitudeDelta = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // start off by default in San Francisco
//        MKCoordinateRegion newRegion;
//        newRegion.center.latitude = 37.786996;
//        newRegion.center.longitude = -122.440100;
//        newRegion.span.latitudeDelta = 0.2;
//        newRegion.span.longitudeDelta = 0.2;
//        
//        [self.mapView setRegion:newRegion animated:YES];

        let currentlocationCenter = CLLocationCoordinate2D(latitude: (currentTrip.latitude as NSString).doubleValue, longitude: (currentTrip.longitude as NSString).doubleValue)
        let currentLocationSpan = MKCoordinateSpan(latitudeDelta: spanLatitudeDelta, longitudeDelta: spanLongitudeDelta)
        
        
        let destinationlocationRegion =  MKCoordinateRegion(center: currentlocationCenter, span: currentLocationSpan)
        
        self.mapView.setRegion(destinationlocationRegion, animated: true)
        
        print(currentTrip)
        // Do any additional setup after loading the view.
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
