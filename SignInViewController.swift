//
//  SignInViewController.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 7/8/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit
import Firebase


class SignInViewController: UIViewController {

    // MARK : Properties
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Check to see if someone is signed in
        if let user = FIRAuth.auth()?.currentUser {
            
            // if they are sign them in using the signedIn function
            self.signedIn(user)
            
        }
        
    }

    // MARK : Helper Methods
    
    //This function creates an instance for the user that can be pasesed along through the different controllers
    func signedIn(user: FIRUser?) {
        
        //Sign in Analytics
        MeasurementHelper.sendLoginEvent()
        
        //Intantiate 
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoUrl = user?.photoURL
        
        AppState.sharedInstance.signedIn = true
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
        
        self.signInActivityIndicator.stopAnimating()
        
        performSegueWithIdentifier(Constants.Segues.SignInToSplashPage, sender: nil)
        
        
    }
    
    // MARK : Actions
    
    @IBAction func signInButton(sender: UIButton) {
        
        //Sign in with credentials
        
        self.signInActivityIndicator.startAnimating()
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                
                self.signInActivityIndicator.stopAnimating()
                
                return
            }
            //Set the display name
            self.setDisplayName(user!)
        })
        
    }
    
    func setDisplayName(user: FIRUser!) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.componentsSeparatedByString("@")[0]
        changeRequest.commitChangesWithCompletion { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
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
