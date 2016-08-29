//
//  ProfileViewController.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 8/24/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties & Outlets
    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayNameTextField.text = AppState.sharedInstance.displayName
        
        self.displayNameTextField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITextField Functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let user = FIRAuth.auth()?.currentUser
        
        if let user = user {
            let changeRequest = user.profileChangeRequest()
            
            //Change the users display name
            changeRequest.displayName = displayNameTextField.text
            changeRequest.commitChangesWithCompletion({ (error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                } else {
                    print("\(user.displayName)")
                    
                    //Change the user's singleton to match the updated display name
                    AppState.sharedInstance.displayName = self.displayNameTextField.text

//                    let tvc = self.presentingViewController as? TripViewController
                    
                    
                 
                    //dismiss the modal view controller
                    self.dismissViewControllerAnimated(true, completion: { 

                        print("Label Chaged")
                    })
                    
                }
            })
            
        }
        
        return true
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
