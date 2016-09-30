//
//  LoginUserController.swift
//  UpsoclApp
//
//  Created by upsocl on 26-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import TwitterKit

class LoginUserController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    // [START viewcontroller Google]
    @IBOutlet weak var signInButtonGoogle: GIDSignInButton!
    // [END viewcontroller Google]
    
    var category = Category()
    var beforeCategory = 0
    let servicesConnection  = ServicesConnection()
    
    // [START viewcontroller Facebook]
    let loginButtonFacebook: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    // [END viewcontroller Facebook]
    
    let loginButtonTwitter = TWTRLogInButton { (session, error) in
        
        let servicesConnection  = ServicesConnection()
        
        if let unwrappedSession = session {
            let twitter = "twitter"
            
            let twitterClient = TWTRAPIClient(userID: unwrappedSession.userID)
            twitterClient.loadUserWithID(unwrappedSession.userID) {
                (user:TWTRUser?, error:NSError?) in
            }
            
            let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let signOutPage = myStroryBoard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
            let signOutPageNav = UINavigationController(rootViewController: signOutPage)
            signOutPageNav.setNavigationBarHidden(signOutPageNav.navigationBarHidden == false, animated: true)
            let appDelegate: AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController =  signOutPageNav
            
            let user = Customer(firstName: unwrappedSession.userName,
                lastName: "--",
                email:  "--",
                location: "--",
                birthday: "00-00-0000",
                imagenURL:  "--",
                token: "qwedsazxc2",
                userId: "0",
                socialNetwork: "facebook",
                socialNetworkTokenId: "tokentFacebook",
                registrationId: "tokentWordpress")
            
            servicesConnection.saveCustomer(user!)
        
        } else {
            NSLog("Login error: %@", error!.localizedDescription);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start GoogleLogin
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //End GoogleLogin
        
        //Start FacebookLogin
        view.addSubview(loginButtonFacebook)
        loginButtonFacebook.frame =  CGRectMake(20, signInButtonGoogle.frame.maxY + 20, UIScreen.mainScreen().bounds.width - 40, 40)
        loginButtonFacebook.delegate = self
        
        if let tokenFacebook = FBSDKAccessToken.currentAccessToken(){
            print (tokenFacebook)
            fetchProfile()
        }
        //End FacebookLogin
        
        // [START viewcontroller Twitter]
        // If using the log in methods on the Twitter instance
        loginButtonTwitter.frame =  CGRectMake(20, loginButtonFacebook.frame.maxY + 20, UIScreen.mainScreen().bounds.width - 40, 40)
        
        self.view.addSubview(loginButtonTwitter)
        // [END viewcontroller Twitter]
        
        
        signInButtonGoogle.hidden = true
        loginButtonFacebook.hidden =  true
        loginButtonTwitter.hidden = true
    }
    
    @IBAction func validCountCategory(sender: UIButton) {
        countCategory ()
    }
    
    func countCategory (){
        let categoryCount = category.countCategory()
        
        if categoryCount <= 1 || beforeCategory <= 1  {
            loginButtonFacebook.hidden =  true
            loginButtonTwitter.hidden = true
            signInButtonGoogle.hidden = true

        } else {
            loginButtonFacebook.hidden = false
            loginButtonTwitter.hidden = false
            signInButtonGoogle.hidden = false
        }
        
        beforeCategory = categoryCount
    }
    
    
    // [------------------------START GOOGLE LOGIN-------------------]
    @IBAction func loginButtonGoogle(sender: UIButton) {
        let categoryCount = category.countCategory()
        if categoryCount < 3 {
            createViewMessage("Debe seleccionar al menos 3 categorias")
        }else{                                                                                                                                                                                                         
            //createViewMessage("Caterias modificadas con éxito..!")
        }
    }
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            signInButtonGoogle.hidden = true
        } else {
            signInButtonGoogle.hidden = false
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
                print ("Google status: " + String(userInfo["statusText"]))
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
        
        print ("Google Login presented")
            
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        print ("Google Login dismissed")
    }
    
    func createViewMessage(message: String){
        let alertView = UIAlertView(title: "Mensaje", message: message, delegate: self, cancelButtonTitle: "Aceptar")
        alertView.tag = 1
        alertView.show()
    }
    // [------------------------FINISH GOOGLE LOGIN-------------------]

    // [------------------------START FACEBOOK LOGIN-------------------]
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print ("FBSDKLoginButton Completado Login")
        fetchProfile()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print ("lFBSDKLoginButton - LoginButtonDidLogOut")

    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            
            let email = user["email"] as? String
            let firstName = user["first_name"] as? String
            let lastName = user["last_name"] as? String
            
            var pictureUrl = "firstName:  " + String(firstName)
            if let picture = user["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                pictureUrl = url
            }
            
            let url = NSURL(string: pictureUrl)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }

                
            }).resume()
            
            let user = Customer(firstName: firstName!,
                                lastName: lastName!,
                                email: email!,
                                location: "--",
                                birthday: "00-00-0000",
                                imagenURL: pictureUrl,
                                token: "qwedsazxc2",
                                userId: "0",
                                socialNetwork: "facebook",
                                socialNetworkTokenId: "tokentFacebook",
                                registrationId: "tokentWordpress")
            
            self.servicesConnection.saveCustomer(user!)
           
            let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let signOutPage = myStroryBoard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
            let signOutPageNav = UINavigationController(rootViewController: signOutPage)
            signOutPageNav.setNavigationBarHidden(signOutPageNav.navigationBarHidden == false, animated: true)
            let appDelegate: AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController =  signOutPageNav
        })
    }
     // [------------------------FINISH FACEBOOK LOGIN-------------------]
    
}
