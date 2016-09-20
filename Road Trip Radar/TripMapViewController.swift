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
    
    
    // This will create an array of members whenever it
    var members:[String] {
        get {
            
            var listOfMembers = [String]()
            
            for (member, _) in currentTrip.members {
                listOfMembers.append(member)
            }
            return listOfMembers
        }
    }
    
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType  = .automotiveNavigation
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    //You need an array of users along with their locations (Points of Interest "the user should be included in the array of points")
    
    
    
    fileprivate var spanLatitudeDelta = 0.2
    fileprivate var spanLongitudeDelta = 0.2
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        // Ensure that the database root is hooked up
        ref = FIRDatabase.database().reference()
        print(" The database root is = \(ref.root)")
        print("The total number of members in this trip is \(members.count)")
        // Change the name of the VC to the name of the trip
        self.title = currentTrip.name
        
        // start off by default in San Francisco
        
        showDestinationRegion()
        createDestinationAnnotation()
        
        startUpdatingLocation()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Perform any additional setup here
        locationManager.requestAlwaysAuthorization()
        print(CLLocationManager.authorizationStatus().rawValue)
        
        // create a reference handle here to update any changes to the user
        _refHandle = self.ref.child("trips").child(currentTrip.key).observe(.value, with: { (snapshot) in
            
            // The current trips details need to be updated here
            
            
            
            // Speaking of which you need to create an array of annotations.. dumbass
            
            // Oh also make sure that if a user is added to the trip it is tracked in realtime
        })
    }
    
    
    // MARK: Helper Functions
    
    //Find all members
    
    
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
        
        
        // Instead of showing the user's location through the locationUI drop a pin
        mapView.showsUserLocation = false
    
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate var RefreshCount = 0
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //go through the locations
        for location in locations {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            print(location.timestamp)
        }
        
        //Get the user's last location in the locations array
        if let lastLocation = locations.last {
            
            //Pull the users latitude & longitude
            let lastLong = ("\(lastLocation.coordinate.longitude)")
            let lastLat = ("\(lastLocation.coordinate.latitude)")
            let lastTimestamp = ("\(lastLocation.timestamp)")
            
            // Create a struct to add the last location
            let lastLocationStruct = Location(latitude: lastLat, longitude: lastLong, timestamp: lastTimestamp)
            //Push the changes to the database in all instances of the trip
            let memberLocationRef = ref.child("users").child(AppState.sharedInstance.userID!).child("location")
            
            memberLocationRef.setValue(lastLocationStruct.toAnyObject())
            
        }
        
        for annotation in self.mapView.annotations {
            
            // If there is an existing user location remove it
            if annotation.isKind(of: UserLocationAnnotation.self) {
                mapView.removeAnnotation(annotation)
                print("User annotation removed")
                
            }
            
            //Add the most recent user location to the mapvView
            else {
                
                let userLocationAnnotation = UserLocationAnnotation(coordinate: (locations.last?.coordinate)!, title: "User", subtitle: "")
                
                mapView.addAnnotation(userLocationAnnotation)
                print("User annotation added")
            }
            
            
            
        }
    
        RefreshCount += 1
        print(RefreshCount)
    }
    
    // MARK: MapView Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var returnedAnnotationView: MKAnnotationView?
        
        //Create a switch for the different types of annotations so that it can load the appropriate NKAnnotationView
        
        switch annotation {
        case is UserLocationAnnotation:
            
            returnedAnnotationView = UserLocationAnnotation.createViewAnnotationForMapView(self.mapView, annotation: annotation)
            
            return returnedAnnotationView!
            
        case is DestinationAnnotation:
            
            returnedAnnotationView = DestinationAnnotation.createViewAnnotationForMapView(self.mapView, annotation: annotation)
            
            return returnedAnnotationView!
            
        default:
            break
        }
    
    return nil
        
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
