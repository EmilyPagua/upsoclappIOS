//
//  LoginUserController.swift
//  UpsoclApp
//
//  Created by upsocl on 26-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class LoginUserController: UIViewController, GIDSignInUIDelegate{
    // [START viewcontroller_vars]
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    // [END viewcontroller_vars]
    
    //@IBOutlet weak var relationsButton: CheckBoxInterest!
    //@IBOutlet weak var popularyButton: CheckBoxInterest!
    
    var category = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start GoogleLogin
        GIDSignIn.sharedInstance().uiDelegate = self
        //End GoogleLogin
        
        /*//Start GoogleLogin
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        if configureError != nil {
            print(configureError)
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        let button = GIDSignInButton(frame: CGRectMake(150, relationsButton.frame.maxY + 20, 100, 100))
        view.addSubview(button)
        //FINISH GoogleLogin*/
    }
    
    // [------------------------START GOOGLE LOGIN-------------------]
    @IBAction func loginButton(sender: UIButton) {
        let categoryCount = category.countCategory()
        if categoryCount < 3 {
            createViewMessage("Debe seleccionar al menos 3 categorias")
        }else{                                                                                                                                                                                                         
            //createViewMessage("Caterias modificadas con éxito..!")
        }
    }
    
    // [START signout_tapped]
    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        statusText.text = "Signed out."
        toggleAuthUI()
        // [END_EXCLUDE]
    }
    // [END signout_tapped]
    
    // [START disconnect_tapped]
    @IBAction func didTapDisconnect(sender: AnyObject) {
        GIDSignIn.sharedInstance().disconnect()
        // [START_EXCLUDE silent]
        statusText.text = "Disconnecting."
        // [END_EXCLUDE]
    }
    // [END disconnect_tapped]
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            signInButton.hidden = true
            signOutButton.hidden = false
            disconnectButton.hidden = false
        } else {
            signInButton.hidden = false
            signOutButton.hidden = true
            disconnectButton.hidden = true
            statusText.text = "Google Sign in\niOS Demo"
        }
    }
    // [END toggle_auth]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: "ToggleAuthUINotification",
                                                            object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
        if (notification.name == "ToggleAuthUINotification") {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                let userInfo:Dictionary<String,String!> =
                    notification.userInfo as! Dictionary<String,String!>
                self.statusText.text = userInfo["statusText"]
            }
        }
    }
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        
        self.presentViewController(viewController, animated: true, completion: nil)
        
        print ("Login presented")
            
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        print ("Login dismissed")
    }
    
    func createViewMessage(message: String){
        let alertView = UIAlertView(title: "Mensaje", message: message, delegate: self, cancelButtonTitle: "Aceptar")
        alertView.tag = 1
        alertView.show()
    }
    
    // [------------------------FINISH GOOGLE LOGIN-------------------]

    /* [------------------------START GOOGLE LOGIN-------------------]
     
     // [START signin_handler]
     func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
     if (error == nil) {
     // Perform any operations on signed in user here.
     let userId = user.userID                  // For client-side use only!
     let idToken = user.authentication.idToken // Safe to send to the server
     let fullName = user.profile.name
     let givenName = user.profile.givenName
     let familyName = user.profile.familyName
     let email = user.profile.email
     
     print ("Data user: " + userId + " " + idToken + " " + fullName + " " + givenName + " " + familyName + " " + email)
     
     GIDSignIn.sharedInstance().signOut()
     
     
     } else {
     print("Error")
     print("\(error.localizedDescription)")
     }
     }
     // [END signin_handler]
     
     
     
     // [------------------------FINISH GOOGLE LOGIN-------------------]*/
    
}
