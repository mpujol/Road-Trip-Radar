//
//  SignInViewController.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 7/8/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase



class SignInViewController: UIViewController {

    // MARK : Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInActivityIndicator: UIActivityIndicatorView!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Create a reference for the user node
        let root = FIRDatabase.database().reference()
        ref = root.child("users")
        
        
        
        //Check to see if someone is signed in
        if let user = FIRAuth.auth()?.currentUser {
            
            // if they are sign them in using the signedIn function
            self.signedIn(user)
            
        }
        
        
        
    }

    // MARK : Helper Methods
    
    //This function creates an instance for the user that can be pasesed along through the different controllers
    func signedIn(_ user: FIRUser?) {
        
        //Sign in Analytics
        MeasurementHelper.sendLoginEvent()
        
        //Instantiate
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoUrl = user?.photoURL
        
        //Create the users id
        AppState.sharedInstance.userID = user?.uid
        
        
        AppState.sharedInstance.signedIn = true
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationKeys.SignedIn), object: nil, userInfo: nil)
        
        print("your display name is \(AppState.sharedInstance.displayName)")
        
        self.signInActivityIndicator.stopAnimating()
        
        performSegue(withIdentifier: Constants.Segues.SignInToSplashPage, sender: nil)
        
        
    }
    
    // MARK : Actions
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        //Sign in with credentials
        
        self.signInActivityIndicator.startAnimating()
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
            
            // Handle any sign in errors
            if let error = error {
                
                
                switch error.code {
                case 17009 : // incorrect password with a valid email
                    print("You kinda miss-typed your password bruh")
                    
                    let incorrectPasswordAlertController = UIAlertController(title: "Incorrect Password", message: "The password you have entered is incorrect", preferredStyle: .alert)
                    let firstAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    
                    incorrectPasswordAlertController.addAction(firstAlertAction)
                    
                    DispatchQueue.main.async(execute: { 
                        self.present(incorrectPasswordAlertController, animated: true, completion: { 
                            self.passwordTextField.text = ""
                        })
                    })
                    
                case 17011 : // incorrect email address
                    print("You kinda miss-typed your password bruh")
                    
                    let incorrectPasswordAlertController = UIAlertController(title: "Invalid Email Address", message: "The email you have entered is not valid", preferredStyle: .alert)
                    let firstAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    
                    incorrectPasswordAlertController.addAction(firstAlertAction)
                    
                    DispatchQueue.main.async(execute: {
                        self.present(incorrectPasswordAlertController, animated: true, completion: {
                            self.passwordTextField.text = ""
                        })
                    })

    
                default:
                    break
                }
                
                print(error.localizedDescription)
                print(error.code)
                
                self.signInActivityIndicator.stopAnimating()
                
                return
            }
            //Set the display name
//            self.setDisplayName(user!)
            self.signedIn(FIRAuth.auth()?.currentUser)
        })
        
    }
    
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        
        self.signInActivityIndicator.startAnimating()
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
            
            //log any account creation errors
            if let error = error {
                
                //Log the error
                print(error.code)
                
                //make some UI to notify the user of any errors & break out of the creation func
                switch error.code {
                case 17007 : // Email already registered
                    let existingUserAlertController = UIAlertController(title: "Existing Email", message: "Someone has registered using the email provided", preferredStyle: .alert)
                    let firstAlertAction  = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    
                    existingUserAlertController.addAction(firstAlertAction)
                    
                    DispatchQueue.main.async(execute: { 
                        self.present(existingUserAlertController, animated: true, completion: { 
                            self.signInActivityIndicator.stopAnimating()
                        })
                    })
                    
                default:
                    break
                }
                
                return
                
            }
            
            
            //Add the newly created user to the database
            
            if let createdUser = user {
                let newUser = User(displayName: createdUser.displayName ?? createdUser.email!, email: createdUser.email!)
                let newUserRef = self.ref.child("\(createdUser.uid)")
                newUserRef.setValue(newUser.toAnyObject())
                
                
            }

            self.signedIn(FIRAuth.auth()?.currentUser)
            
            
        })
        
    }
    
    func setDisplayName(_ user: FIRUser!) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
        changeRequest.commitChanges { (error) in
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
