
//
//  AppDelegate.swift
//  appupsocl
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import CoreLocation
//import Fabric
//import TwitterKit
import Google
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var category = Category()
    var servicesConnection = ServicesConnection()
    
    // var Google
    var gcmSenderID: String?
    var registrationOptions = [String: AnyObject]()
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    let subscriptionTopic = "/topics/global"
    var registrationToken: String?
    var connectedToGCM = false
    var subscribedToTopic = false
    //end Google

    
    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
                                             scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }


    // [START didfinishlaunching Google, Facebook]
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        //Initialize sign-in Google
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configurando el servicio de Google: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self  //Login Google
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        
        print ("gcmSenderId   ",gcmSenderID ?? "tokent")
        
       // [START register_for_remote_notifications]
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
        }
        // [END register_for_remote_notifications]
        
        // [START start_gcm_service]
        let gcmConfig = GCMConfig.default()
        gcmConfig?.receiverDelegate = self
        GCMService.sharedInstance().start(with: gcmConfig)
        // [END start_gcm_service]
        
        
        
        // Initialize sign-in Facebook
       // FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // Initialize sign-in Twitter
        //Fabric.with([Twitter.self])
        
        //category.clearCategoryPreference()

        // [START tracker_swift]
        // Configure tracker from GoogleService-Info.plist.
        //GGLContext.sharedInstance().configureWithError(&configureError)
      //  assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        //let gai = GAI.sharedInstance()
        //gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        //gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
        // [END tracker_swift]
        
        
        print ("--------------------------Inicio------------------")
        //Get social Network
        //let preferences = UserDefaults.standard
        //let networkName  = preferences.object(forKey: "socialNetwork") as! String
         //end social Network
    
        
        // [END register_for_remote_notifications]
        // [START start_gcm_service]
     /*   let gcmConfig = GCMConfig.default()
        gcmConfig?.receiverDelegate = self
        GCMService.sharedInstance().start(with: gcmConfig)*/
        // [END start_gcm_service]
    
        return true
    }
    
    // [END didfinishlaunching Google, Facebook]
    
    func mainView(){
       
        let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let signOutPage = myStroryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let signOutPageNav = UINavigationController(rootViewController: signOutPage)
        signOutPageNav.setNavigationBarHidden(signOutPageNav.isNavigationBarHidden == false, animated: true)
        
        let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController =  signOutPageNav
    }
    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // [START connect_gcm_service]
        GCMService.sharedInstance().connect(handler: { error -> Void in
            if let error = error as? NSError {
                print("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                print("Connected to GCM")
                // [START_EXCLUDE]
                self.subscribeToTopic()
                // [END_EXCLUDE]
            }
        })
         // [END connect_gcm_service]
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func validSocialNetwork(socialNetworkName: String) -> Bool {
        var flag: Bool = true
        
        if socialNetworkName.isEmpty == false {
            if  GIDSignIn.sharedInstance().hasAuthInKeychain() {
                mainView()
                flag = false
            }
            /*
            if FBSDKAccessToken.current() != nil {
                mainView()
                flag = false
            }*/
        }
        return flag
    }
    
    
    // [------------------------START GOOGLE-------------------]
    
    
    // [START openurl]
     func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
     
        let signIn =  GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
     
        if signIn { return signIn}
     
     /*return  FBSDKApplicationDelegate.sharedInstance().application(application, open: url,
     sourceApplication: sourceApplication,
     annotation: annotation)*/
        return false
     }
     // [END openurl]
     
    
     @available(iOS 9.0, *)
     func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
     
     var signIn: Bool = false
     signIn = GIDSignIn.sharedInstance().handle(url,
     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
     
     if (signIn){
     return signIn
        }
    
     /*signIn = FBSDKApplicationDelegate.sharedInstance().application(application, open: url,
     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
     */
     return signIn
     }
    
    // [START signin_handler]
     func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = "112233" //user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            _ = user.profile.name
            let fullName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let imagenURL = user.profile.imageURL(withDimension: 50)
            let birthday =  "00-00-0000"
     
            let user = Customer(firstName: fullName!,
                                lastName: familyName!,
                                email:  email!,
                                location: "--",
                                birthday: birthday,
                                imagenURL: imagenURL!,
                                token: "qwedsazxc2",
                                userId: userId,
                                socialNetwork: "google",
                                socialNetworkTokenId: idToken!,
                                registrationId: "tokentWordpress")
     
            servicesConnection.saveCustomer(user!)
     
            // [START_EXCLUDE]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
     
     
            let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let signOutPage = myStroryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            let signOutPageNav = UINavigationController(rootViewController: signOutPage)
            signOutPageNav.setNavigationBarHidden(signOutPageNav.isNavigationBarHidden == false, animated: true)
     
            let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController =  signOutPageNav
            } else {
                print("\(error.localizedDescription)")
     
                // [START_EXCLUDE silent]
                NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
                // [END_EXCLUDE]
            }
    
     }
    // [END signin_handler]
    
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
    
    // [START receive_apns_token]
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: Data ) {
        
        print ("deviceTokent ", deviceToken)
        let instanceIDConfig = GGLInstanceIDConfig.default()
        instanceIDConfig?.delegate = self
        GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken as AnyObject,
                               kGGLInstanceIDAPNSServerTypeSandboxOption:true as AnyObject]
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
                                             scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }
    // [END get_gcm_reg_token]
    

    // [------------------------FINISH GOOGLE -------------------]
    
    func registrationHandler(_ registrationToken: String?, error: Error?) {
        if let registrationToken = registrationToken {
            self.registrationToken = registrationToken
            print("Registration Token: \(registrationToken)")
            self.subscribeToTopic()
            let userInfo = ["registrationToken": registrationToken]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
        } else if let error = error {
            print("Registration to GCM failed with error: \(error.localizedDescription)")
            let userInfo = ["error": error.localizedDescription]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: self.registrationKey), object: nil, userInfo: userInfo)
        }
    }
    
    func subscribeToTopic() {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        if registrationToken != nil && connectedToGCM {
            GCMPubSub.sharedInstance().subscribe(withToken: self.registrationToken,
                                                 topic: subscriptionTopic,
                                                 options: nil,
                                                 handler: {
                                                    error -> Void in
                                                        if let error = error as? NSError {
                                                            // Treat the "already subscribed" error more gently
                                                            if error.code == 3001 {
                                                                print("Already subscribed to \(self.subscriptionTopic)")
                                                            } else {
                                                                print("Subscription failed: \(error.localizedDescription)")
                                                            }
                                                        } else {
                                                            self.subscribedToTopic = true
                                                            NSLog("Subscribed to \(self.subscriptionTopic)")
                                                        }
                                                })
        }
    }
        
    
    // [START receive_apns_token_error]
    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: Error ) {
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
        // [END receive_apns_token_error]
        let userInfo = ["error": error.localizedDescription]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: registrationKey), object: nil, userInfo: userInfo)
    }
    
    // [START ack_message_reception]
    func application( _ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
        GCMService.sharedInstance().appDidReceiveMessage(userInfo)
        // Handle the received message
        // [START_EXCLUDE]
        NotificationCenter.default.post(name: Notification.Name(rawValue: messageKey), object: nil,
                                        userInfo: userInfo)
        // [END_EXCLUDE]
    }
    
    func application( _ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                      fetchCompletionHandler handler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Notification received: \(userInfo)")
        // This works only if the app started the GCM service
       // GCMService.sharedInstance().appDidReceiveMessage(userInfo)
        //NotificationCenter.default.post(name: Notification.Name(rawValue: messageKey), object: nil,
          //                              userInfo: userInfo)
       // handler(UIBackgroundFetchResult.noData)

        
        print ("redireccionar")
        // [END_EXCLUDE]
    }
}

