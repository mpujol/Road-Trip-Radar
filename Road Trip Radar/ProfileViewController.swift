//
//  ProfileViewController.swift
//  Road Trip Radar
//
//  Created by Michael Pujol on 8/24/16.
//  Copyright © 2016 Michael Pujol. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        //Check to see if the user is valid
        let user = FIRAuth.auth()?.currentUser
        
        
        if let user = user {
            let changeRequest = user.profileChangeRequest()
            
            //Change the users display name
            changeRequest.displayName = displayNameTextField.text
            changeRequest.commitChanges(completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                } else {
                    print("\(user.displayName)")
                    
                    //Change the user's singleton to match the updated display name
                    AppState.sharedInstance.displayName = self.displayNameTextField.text

//                    let tvc = self.presentingViewController as? TripViewController
                    
                    
                 
                    //dismiss the modal view controller
                    self.dismiss(animated: true, completion: { 

                        print("Label Chaged")
                    })
                    
                }
            })
            
        }
        
        return true
    }
    
    func changeUserName() {
        
    }
    
    // MARK: Action
    
    @IBAction func tapUserPhoto(_ sender: UITapGestureRecognizer) {
        
        //here is where you want to bring up a choice between taking a new picture or selecting an existing one
        
        //Create an Alert Controller to let the user decide where to get a photo from
        
        let selectPhotoSourceAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            
            //Check to see if the device has a camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {

                let imagePicker = UIImagePickerController()
                
                imagePicker.sourceType = .camera
                
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
                
            } else {
                //let the user know that the device does not have a camera... which is a  surprise
                
                let noCameraAlertController = UIAlertController(title: "No Camera", message: "Your device does not have a camera", preferredStyle: .alert)
                
                let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                
                noCameraAlertController.addAction(dismissAction)
                
                self.present(noCameraAlertController, animated: true, completion: nil)
            }
            
        }
        
        selectPhotoSourceAlertController.addAction(takePhotoAction)
        
        let selectPhotoAction = UIAlertAction(title: "Select Profile Picture", style: .default) { (action) in
            //Open the cameral Roll
        }
        
        selectPhotoSourceAlertController.addAction(selectPhotoAction)
        
        let cancelPhotoSourceAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //Dismiss the ActionSheet VC
            selectPhotoSourceAlertController.dismiss(animated: true, completion: nil)
        }
        
        selectPhotoSourceAlertController.addAction(cancelPhotoSourceAlertAction)
        
        self.present(selectPhotoSourceAlertController, animated: true, completion: nil)
        
        
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
