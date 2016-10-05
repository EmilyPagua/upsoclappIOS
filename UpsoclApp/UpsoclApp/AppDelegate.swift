
//
//  AppDelegate.swift
//  UpsoclApp
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import CoreLocation
import Fabric
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var category = Category()
    var servicesConnection = ServicesConnection()
    
    // [START didfinishlaunching Google, Facebook]
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // Initialize sign-in Google
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configurando el servicio de Google: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        
        // Initialize sign-in Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // Initialize sign-in Twitter
        Fabric.with([Twitter.self])
        
        category.clearCategoryPreference()

        
        print ("--------------------------Inicio------------------")

        let preferences = NSUserDefaults.standardUserDefaults()
        let socialNetworkName  = preferences.objectForKey("socialNetwork")
        
        print (socialNetworkName)
        if socialNetworkName != nil {
            if  GIDSignIn.sharedInstance().hasAuthInKeychain(){
                print("user is signed in")
                mainView()
                return false
            }else{
                print("GIDSignIn user is NOT signed in")
            }
    
            if FBSDKAccessToken.currentAccessToken() != nil {
                print("tokenFacebook user is signed in")
                mainView()
                return false
            }else{
                print("tokenFacebook user is NOT signed in")
            }
            print("Twitter user is signed in")
            self.mainView()
            return false
        }
        print ("--------------------------Inicio FIN ------------------")
        return true
    }
    // [END didfinishlaunching Google, Facebook]
    
    func mainView(){
        
        let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signOutPage = myStroryBoard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
        let signOutPageNav = UINavigationController(rootViewController: signOutPage)
        signOutPageNav.setNavigationBarHidden(signOutPageNav.navigationBarHidden == false, animated: true)
        
        let appDelegate: AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController =  signOutPageNav
    
    
    }
    
    
    // [------------------------START GOOGLE LOGIN-------------------]
    // [START openurl]
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        let signIn =  GIDSignIn.sharedInstance().handleURL(url,
                                                        sourceApplication: sourceApplication,
                                                        annotation: annotation)
       
        if signIn {
            return signIn
        }
        
        return  FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url,
                                                                      sourceApplication: sourceApplication,
                                                                      annotation: annotation)

    }
    // [END openurl]

    
    @available(iOS 9.0, *)
    func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        
        var signIn: Bool = false
        signIn = GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        
        if (signIn){
            return signIn}
        
        signIn = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url,
                                                                       sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                                       annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        
        return signIn
    }
    
    // [START signin_handler]
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = "112233" //user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            _ = user.profile.name
            let fullName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let imagenURL = user.profile.imageURLWithDimension(50)
            let birthday =  "00-00-0000"
            
            let user = Customer(firstName: fullName,
                                lastName: familyName,
                                email:  email,
                                location: "--",
                                birthday: birthday,
                                imagenURL:  String(imagenURL),
                                token: "qwedsazxc2",
                                userId: userId,
                                socialNetwork: "google",
                                socialNetworkTokenId: idToken,
                                registrationId: "tokentWordpress")
            
            servicesConnection.saveCustomer(user!)
            
            // [START_EXCLUDE]
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification",
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
            
            
            let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let signOutPage = myStroryBoard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
            let signOutPageNav = UINavigationController(rootViewController: signOutPage)
            signOutPageNav.setNavigationBarHidden(signOutPageNav.navigationBarHidden == false, animated: true)
            
            let appDelegate: AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController =  signOutPageNav
        } else {
            print("Error  " + error.localizedDescription)
            
            // [START_EXCLUDE silent]
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification", object: nil, userInfo: nil)
            // [END_EXCLUDE]
        }
    }
    // [END signin_handler]
    
    
    // [START disconnect_handler]
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NSNotificationCenter.defaultCenter().postNotificationName(
            "ToggleAuthUINotification",
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
    // [------------------------FINISH GOOGLE LOGIN-------------------]
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

