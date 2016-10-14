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
    @IBOutlet weak var loginButtonFacebook: FBSDKLoginButton?  = {
    let button = FBSDKLoginButton()
    button.readPermissions = ["email"]
    return button
    }()
   
    // [END viewcontroller Facebook]
    
    @IBOutlet weak var loginButtonTwitter: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start GoogleLogin
        GIDSignIn.sharedInstance().uiDelegate = self
        //End GoogleLogin
        
        //Start FacebookLogin
        loginButtonFacebook!.delegate = self
        
        /*Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("1 \(session!.userName)");
            } else {
                print("5 error: \(error!.localizedDescription)");
            }
        }
        */
        //End FacebookLogin
        //loginButtonFacebook!.hidden =  true
        //loginButtonTwitter.hidden = true
        //signInButtonGoogle.hidden = true
    }
    
    @IBAction func validarLogin(_ sender: AnyObject) {
        
        Twitter.sharedInstance().logIn { session, error in
            if (session != nil) {
                print("1 \(session!.userName)");
                Twitter.sharedInstance().sessionStore.logOutUserID((session?.authToken)!)
            } else {
                print("5 error: \(error!.localizedDescription)");
            }
        }
        
        // If using the log in methods on the Twitter instance
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
                print("2 \(session!.userName)");
                Twitter.sharedInstance().sessionStore.logOutUserID((session?.authToken)!)
                
                // Swift
                let client = TWTRAPIClient.withCurrentUser()
                let request = client.urlRequest(withMethod: "GET",
                                                          url: "https://api.twitter.com/1.1/account/verify_credentials.json",
                                                          parameters: ["include_email": "true", "skip_status": "true"],
                                                          error: nil)
                
                client.sendTwitterRequest(request) { response, data, connectionError in
                    let nsdata = NSData(data: data!) as Data
                    let json : AnyObject!
                    do {
                        json = try JSONSerialization.jsonObject(with: nsdata, options: []) as? [String:AnyObject] as AnyObject!
                       // print (json)
                        let user = Customer(firstName: json["name"] as! String,
                                            lastName: ".",
                                            email: "pruebaIOS@gmail.com",
                                            location: "--",
                                            birthday: "00-00-0000",
                                            imagenURL: json["profile_image_url"] as! String,
                                            token: "qwedsazxc2",
                                            userId: "0",
                                            socialNetwork: "twitter",
                                              socialNetworkTokenId: "tokentFacebook",
                                            registrationId: "tokentWordpress")
                        
                        print (user?.firstName)
                        self.servicesConnection.saveCustomer(user!)
                        
                        let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let signOutPage = myStroryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        let signOutPageNav = UINavigationController(rootViewController: signOutPage)
                        signOutPageNav.setNavigationBarHidden(signOutPageNav.isNavigationBarHidden == false, animated: true)
                        let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController =  signOutPageNav
                        
                        
                    }catch let error as NSError{
                        print (error.localizedDescription)
                        json=nil
                        return
                    }
                }
                
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
            
        }
        
    }
    
    @IBAction func validCountCategory(_ sender: UIButton) {
        //countCategory ()
    }
    
    func countCategory (){
        let categoryCount = category.countCategory()
        
        if categoryCount <= 1 || beforeCategory <= 1  {
            loginButtonFacebook!.isHidden =  true
            loginButtonTwitter.isHidden = true
            signInButtonGoogle.isHidden = true

        } else {
            loginButtonFacebook!.isHidden = false
            loginButtonTwitter.isHidden = false
            signInButtonGoogle.isHidden = false
        }
        
        beforeCategory = categoryCount
    }
    
    
    // [------------------------START GOOGLE LOGIN-------------------]
    @IBAction func loginButtonGoogle(_ sender: UIButton) {
        let categoryCount = category.countCategory()
        if categoryCount < 3 {
            createViewMessage("Debe seleccionar al menos 3 categorias")
        }else{                                                                                                                                                                                                         
            //createViewMessage("Categorias modificadas con éxito..!")
        }
    }
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            signInButtonGoogle.isHidden = true
        } else {
            signInButtonGoogle.isHidden = false
        }
    }
    // [END toggle_auth]
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                            name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                            object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: Notification) {
        
        if String(describing: notification.name) == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if (notification as NSNotification).userInfo != nil {
                let userInfo:Dictionary<String,String?> =
                    (notification as NSNotification).userInfo as! Dictionary<String,String?>
                print ("Google status: " + String(describing: userInfo["statusText"]))
            }
        }
    }
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
        
        print ("Google Login presented")
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
                dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
        print ("Google Login dismissed")
    }
    
    func createViewMessage(_ message: String){
        let alertView = UIAlertView(title: "Mensaje", message: message, delegate: self, cancelButtonTitle: "Aceptar")
        alertView.tag = 1
        alertView.show()
    }
    // [------------------------FINISH GOOGLE LOGIN-------------------]

    // [------------------------START FACEBOOK LOGIN-------------------]
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print ("FBSDKLoginButton Completado Login")
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print ("lFBSDKLoginButton - LoginButtonDidLogOut")

    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            /*
            let email = user["email"] as? String
            let firstName = user["first_name"] as? String
            let lastName = user["last_name"] as? String
            
            var pictureUrl = "firstName:  " + String(firstName)
            if let picture = user["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                pictureUrl = url
            }
            
            let url = URL(string: pictureUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
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
           */
            let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let signOutPage = myStroryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            let signOutPageNav = UINavigationController(rootViewController: signOutPage)
            signOutPageNav.setNavigationBarHidden(signOutPageNav.isNavigationBarHidden == false, animated: true)
            let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController =  signOutPageNav
        })
    }
     // [------------------------FINISH FACEBOOK LOGIN-------------------]
    
}
