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
    @IBOutlet weak var tableView: UITableView!
    
    var trips = [Trip]()
    var ref: FIRDatabaseReference!
    
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    
    // MARK: Constants
    
    struct Constants {
        static let reuseIdentifier = "TripCell"
        static let segueIdentifier = "TripDetails"
        static let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    }
    
    // MARK: Table View Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Trips"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath) as! TripTableViewCell
        
        cell.tripNameLabel.text = self.trips[(indexPath as NSIndexPath).row].name
        

        cell.numberOfMembersLabel.text = "Total Members: \(self.trips[(indexPath as NSIndexPath).row].totalMembers)"
        
        return cell
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Ensure that the database is hooked up
        ref = FIRDatabase.database().reference()
        
        setUserInformation()
        
        print(ref.root)
        
        print(trips.count)
        
    }
    
    func setUserInformation() {
        
        self.usernameLabel.text = AppState.sharedInstance.displayName //FIRAuth.auth()?.currentUser?.displayName
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("TVC Appeared \(AppState.sharedInstance.displayName)")
        
        self.setUserInformation()
        
        self.trips.removeAll()
        //Listen for new messages in the user-trips
        
        _refHandle = self.ref.child("users").child("\(AppState.sharedInstance.userID!)").child("user-trips").observe(.value, with: { snapshot in
            
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
                for (key,value) in trip.members {
                    print("\(key):\(value)")
                }
            }
            
            self.tableView.reloadData()
        
            
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeObserver(withHandle: _refHandle)
    }

    // MARK: Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func addTripButton(_ sender: UIBarButtonItem) {
        
        //Add trip information to the User
        
        let memberReference = self.ref.child("users").child("\(AppState.sharedInstance.userID)").child("trips")
        
        print(memberReference.description())
        
        //Add member information to the Trips
        
        let tripRef = self.ref.child("trips")

        let sampleTrip = Trip(name: "That Place", addedByUser: AppState.sharedInstance.displayName!, latitude: "37.786996", longitude: "-122.440100", members: ["\(AppState.sharedInstance.userID!)": "Going"])
        
        let key = tripRef.childByAutoId().key
        
        let childUpdates = [
            "/trips/\(key)": sampleTrip.toAnyObject(),
            "/users/\(AppState.sharedInstance.userID!)/user-trips/\(key)": sampleTrip.toAnyObject()
        ]
        
        ref.updateChildValues(childUpdates)

        print("Trip Added")
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constants.segueIdentifier {
            
//            get the data from that specific trip and pass it along to the destination view controller
            let rowTapped = ((self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row)!
            let tripToSend = trips[rowTapped]
            print(rowTapped)
            print(tripToSend)
            let tmvc = segue.destination as! TripMapViewController
            
            tmvc.currentTrip = tripToSend

        }
        
    }
    

}
