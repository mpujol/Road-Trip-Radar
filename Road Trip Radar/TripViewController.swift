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


class TripViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    // MARK : Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var trips = [Trip]()
    var ref: FIRDatabaseReference!
    
    private var _refHandle: FIRDatabaseHandle!
    
    
    // MARK : Constants
    
    private let reuseIdentifier = "TripCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    // MARK : Collection View Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //Check to see if you're logged in - Sanity check
        if let user = FIRAuth.auth()?.currentUser {
            // there is still a user out there
            
            print(user.displayName)
        }
        
        //Ensure that the database is hooked up
        ref = FIRDatabase.database().reference()
        
        print(ref.root)
        
        print(trips.count)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.trips.removeAll()
        //Listen for new messages in the Firebase database
        
        _refHandle = self.ref.child("trip").observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            var newTrips = [Trip]()
            
            for trip in snapshot.children {
                let specificTrip = Trip(snapshot: trip as! FIRDataSnapshot)
                
                print(specificTrip.name)
                
                newTrips.append(specificTrip)
                
            }
            
            self.trips = newTrips
            
        })
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.ref.removeObserverWithHandle(_refHandle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func addTripButton(sender: UIBarButtonItem) {
        
        let tripRef = self.ref.child("trip")
        
        let sampleTrip = Trip(name: "The Gym", addedByUser: AppState.sharedInstance.displayName!)
        
        tripRef.setValue(sampleTrip.toAnyObject())
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
