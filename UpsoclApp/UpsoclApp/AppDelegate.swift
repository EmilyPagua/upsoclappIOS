
//
//  AppDelegate.swift
//  UpsoclApp
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    
    // [------------------------START GOOGLE LOGIN-------------------]
    // [START didfinishlaunching]
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configurando el servicio de Google: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    // [END didfinishlaunching]
    
    
    // [START openurl]
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    // [END openurl]

    
    @available(iOS 9.0, *)
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    // [START signin_handler]
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = "112233" //user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let firstName = user.profile.name
            let fullName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let imagenURL = user.profile.imageURLWithDimension(50)
            let socialNetwork = "google"
            let birthday =  ""
            let tocken =  ""
            
            let preferences = NSUserDefaults.standardUserDefaults()
            preferences.setValue(email , forKey: Customer.PropertyKey.email)
            preferences.setValue(fullName, forKey: Customer.PropertyKey.firstName )
            preferences.setValue(familyName, forKey: Customer.PropertyKey.lastName)
            preferences.setValue(birthday, forKey: Customer.PropertyKey.birthday )
            preferences.setValue(String(imagenURL), forKey: Customer.PropertyKey.imagenURL)
            preferences.setValue(tocken, forKey: Customer.PropertyKey.token)
            preferences.setValue(userId, forKey: Customer.PropertyKey.userId)
            preferences.setValue(socialNetwork, forKey: Customer.PropertyKey.socialNetwork)
            preferences.setValue(idToken, forKey: Customer.PropertyKey.socialNetworkTokenId)
            
            var location =  ""
            let allLocaleIdentifiers : Array<String> = NSLocale.availableLocaleIdentifiers() as Array<String>
            let currentLocale = NSLocale.currentLocale()
            let countryCode = currentLocale.objectForKey(NSLocaleCountryCode) as? String
            let englishLocale : NSLocale = NSLocale.init(localeIdentifier : countryCode! )

            for anyLocaleID in allLocaleIdentifiers {
                
                // get the english name
                let theEnglishName : String? = englishLocale.displayNameForKey(NSLocaleIdentifier, value: anyLocaleID)
                
                ///NO olvidar // colocar si el theEnglishName es igual al codigo del pais
                if anyLocaleID.rangeOfString(countryCode!) != nil {
                    print("Identifier   : \(anyLocaleID)\nName         : \(theEnglishName!)\n")
                    location = theEnglishName!
                }
            }
            if location.isEmpty{
                preferences.setValue("No identificado", forKey: Customer.PropertyKey.location )
            }else{
                preferences.setValue(location, forKey: Customer.PropertyKey.location )
            }

            preferences.synchronize()

            
            // [START_EXCLUDE]
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification",
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
            
            
            let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            //let signOutPage = myStroryBoard.instantiateViewControllerWithIdentifier("SignOutViewController") as! SignOutViewController
            let signOutPage = myStroryBoard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
            
            let signOutPageNav = UINavigationController(rootViewController: signOutPage)
            
            signOutPageNav.setNavigationBarHidden(signOutPageNav.navigationBarHidden == false, animated: true)
            
            let appDelegate: AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController =  signOutPageNav
            
            
            //self.window?.rootViewController =  signOutPageNav
            
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
    
    
     //Funcion original, fue reemplazada por google login
     /*func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
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

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }*/
}

