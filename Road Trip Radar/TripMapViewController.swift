//
//  TripMapViewController.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 8/18/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import FirebaseDatabase
import FirebaseAuth

class TripMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var currentTrip: Trip!
    
    var ref: FIRDatabaseReference!
    
    private var _refHandle: FIRDatabaseHandle!
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        _locationManager.activityType  = .AutomotiveNavigation
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 1000.0
        return _locationManager
    }()
    
    
    private var spanLatitudeDelta = 0.2
    private var spanLongitudeDelta = 0.2
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Ensure that the database root is hooked up
        ref = FIRDatabase.database().reference()
        print(" The database root is = \(ref.root)")
        
        // Change the name of the VC to the name of the trip
        self.title = currentTrip.name
        
        // start off by default in San Francisco
        
        showDestinationRegion()
        createDestinationAnnotation()
        startUpdatingLocation()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Perform any additional setup here
        locationManager.requestAlwaysAuthorization()
        print(CLLocationManager.authorizationStatus().rawValue)
        
        // create a reference handle here to update any changes to the user
        _refHandle = self.ref.child("trips").child(currentTrip.key).observeEventType(.Value, withBlock: { (snapshot) in
            // if any of the user's coordinates changes you need to referesh the annotations
            
            // Speaking of which you need to create an array of annotations.. dumbass
        })
    }
    
    
    // MARK: Helper Functions
    
    // Final Destination
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
    
    // Location Tracking
    func startUpdatingLocation() {
        
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var RefreshCount = 0
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //go through the locations
        for location in locations {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            print(location.timestamp)
        }
        
        //Get the user's last location in the locations array
        var lastLocation = locations.last
        
        //Pull the users latitude & longitude
        var lastLong = lastLocation?.coordinate.longitude
        var lastLat = lastLocation?.coordinate.latitude
        
        
        //Push the changes to the database in all instances of the trip
        
        
        
        RefreshCount += 1
        print(RefreshCount)
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
