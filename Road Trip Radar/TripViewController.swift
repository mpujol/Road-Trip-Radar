//
//  TripViewController.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 7/13/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class TripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    // MARK: Properties
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    var user:FIRUser? {
        get {
            if let currentUser = FIRAuth.auth()?.currentUser {
                print(currentUser.displayName)
                    return currentUser
            }
            print("No user signed in")
            return nil
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var trips = [Trip]()
    var ref: FIRDatabaseReference!
    
    private var _refHandle: FIRDatabaseHandle!
    
    
    // MARK: Constants
    
    private let reuseIdentifier = "TripCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    // MARK: Table View Methods
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Trips"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TripTableViewCell
        
        cell.tripNameLabel.text = self.trips[indexPath.row].name
        cell.addedByUser.text = self.trips[indexPath.row].addedByUser
        
        return cell
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Ensure that the database is hooked up
        ref = FIRDatabase.database().reference()
        
        self.usernameLabel.text = FIRAuth.auth()?.currentUser?.displayName
        self.userEmailLabel.text = FIRAuth.auth()?.currentUser?.email
        
        print(ref.root)
        
        print(trips.count)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.trips.removeAll()
        //Listen for new messages in the user-trips
        
        _refHandle = self.ref.child("users").child("\(AppState.sharedInstance.userID!)").child("user-trips").observeEventType(.Value, withBlock: { snapshot in
            
            print("Snapshot value is \(snapshot.value)")
            
            var newTrips = [Trip]()
            
            for trip in snapshot.children {
                let specificTrip = Trip(snapshot: trip as! FIRDataSnapshot)
                
                newTrips.append(specificTrip)
                
            }
            
            self.trips = newTrips
            for trip in self.trips {
                print(trip.name)
                print(trip.members.count)
            }
            
            self.tableView.reloadData()
            
        })
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.ref.removeObserverWithHandle(_refHandle)
    }

    // MARK: Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func addTripButton(sender: UIBarButtonItem) {
        
        //Add trip information to the User
        
        let memberReference = self.ref.child("users").child("\(FIRAuth.auth()?.currentUser?.uid)").child("trips")
        
        print(memberReference.description())
        
        //Add member information to the Trips
        
        let tripRef = self.ref.child("trips")
        //Works!
        let sampleTrip = Trip(name: "That Place", addedByUser: AppState.sharedInstance.displayName!, latitude: "X", longitude: "Y", members: ["\(AppState.sharedInstance.userID!)": "Going"])
        
//        let sampleTrip = Trip(name: "The Gym", addedByUser: AppState.sharedInstance.displayName!, latitude: "37.67251", longitude: "-122.472200")
        
        let key = tripRef.childByAutoId().key
        
        let childUpdates = [
            "/trips/\(key)": sampleTrip.toAnyObject(),// THis is effed up.... why?
            "/users/\(AppState.sharedInstance.userID!)/user-trips/\(key)": sampleTrip.toAnyObject()
        ]
        
        ref.updateChildValues(childUpdates)

        print("Trip Added")
        
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
