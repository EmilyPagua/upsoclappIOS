//
//  AppDelegate.swift
//  appupsocl
//
//  Created by Emily.pagua on 10/10/16.
//

import UIKit
import CoreData
import CoreLocation
import Fabric
import TwitterKit
import Google
import UserNotifications
import GoogleMobileAds

@UIApplicationMain
class AppDelegate:  UIResponder, UIApplicationDelegate, GIDSignInDelegate,
                    GGLInstanceIDDelegate, GCMReceiverDelegate, UNUserNotificationCenterDelegate {
    
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
        NSLog("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
                                             scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
    }


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSLog ("--------------------------Inicio------------------")
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))

        self.googleStartConfig(application)
        self.facebookStartConfig(application, didFinishLaunchingWithOptions: launchOptions)
        self.twitterStartConfig()
        self.googleAnalyticsStart()
        
        if self.validLoginUser(){
            self.sendActivityMain()
        }else{
            category.clearCategoryPreference()
        }
    
        //Admob
        GADMobileAds.configure(withApplicationID: "ca-mb-app-pub-7682123866908966/2346534963")
        
        return true
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // [START connect_gcm_service]
        GCMService.sharedInstance().connect(handler: { error -> Void in
            if let error = error as? NSError {
                NSLog("Could not connect to GCM: \(error.localizedDescription)")
            } else {
                self.connectedToGCM = true
                NSLog("Connected to GCM")
                self.subscribeToTopic()
            }
        })
        FBSDKAppEvents.activateApp()
    }
    
    
    // [------------------------START GOOGLE-------------------]
    // [START openurl]
     func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        return self.isSignIn(application, open: url, sourceApplication: sourceApplication! ,annotation:  annotation)
        
     }
     // [END openurl]
     
    
     @available(iOS 9.0, *)
     func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
  
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        return self.isSignIn(application, open: url, sourceApplication: sourceApplication ,annotation:  annotation)
     }
    
    // [START signin_handler]
     func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        var userInfo: [AnyHashable : Any]? = nil
        if (error == nil) {
            let userLogin  =  UserLogin(email: user.profile.email ?? "NA",
                                        firstName: user.profile.givenName ?? "NA",
                                        lastName: user.profile.familyName ?? "NA",
                                        location : "--" ,
                                        birthday: "00-00-0000" ,
                                        imagenURL: user.profile.imageURL(withDimension: 50)! as URL,
                                        token: "qwedsazxc2",
                                        userId: "112233",
                                        socialNetwork: "google" as String,
                                        socialNetworkTokenId: user.authentication.idToken! ,
                                        registrationId: "tokentWordpress" )
            
            UserSingleton.sharedInstance.removeUseLogin()
            UserSingleton.sharedInstance.addUser(userLogin)
            NSLog("USER_LOGIN:  ")
            
            userInfo = ["statusText": "Signed in user:\n\(userLogin.email)"]
        } else {
            NSLog("\(error.localizedDescription)")
            userInfo = nil
        }
        
        NotificationCenter.default.post( name: Notification.Name(rawValue: SocialNetwork.PropertyKey.ToggleAuthUINotification),
                                         object: nil,
                                         userInfo: userInfo)
        
        if userInfo != nil{
            self.sendActivityMain()
        }
        
     }
    // [END signin_handler]
    
    
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error!) {
        // [START_EXCLUDE]
        NotificationCenter.default.post(name: Notification.Name(rawValue: SocialNetwork.PropertyKey.ToggleAuthUINotification),
                                        object: nil,
                                        userInfo: ["statusText": "User has disconnected."])
        //  [END_EXCLUDE]
    }
    // [END disconnect_handler]
    
    
    // [START receive_apns_token]
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: Data ) {
        
        NSLog ("deviceTokent ", deviceToken.description)
        let instanceIDConfig = GGLInstanceIDConfig.default()
        instanceIDConfig?.delegate = self
        GGLInstanceID.sharedInstance().start(with: instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken as AnyObject,
                               kGGLInstanceIDAPNSServerTypeSandboxOption:true as AnyObject]
        
        GGLInstanceID.sharedInstance().token(withAuthorizedEntity: gcmSenderID,
                                             scope: kGGLInstanceIDScopeGCM,
                                             options: registrationOptions,
                                             handler: registrationHandler)
    }
    // [END get_gcm_reg_token]
    

    // [------------------------FINISH GOOGLE -------------------]
    
    func registrationHandler(_ registrationToken: String?, error: Error?) {
        
        var userInfo: [AnyHashable : Any]? = nil
        
        if let registrationToken = registrationToken {
            self.registrationToken = registrationToken
            self.subscribeToTopic()
            userInfo = ["registrationToken": registrationToken]
        } else if let error = error {
            NSLog("Registration to GCM failed with error: \(error.localizedDescription)")
            userInfo = ["error": error.localizedDescription]
            
        }
        
        NotificationCenter.default.post( name: Notification.Name(rawValue: self.registrationKey),
                                         object: nil,
                                         userInfo: userInfo)
    }
    
    func subscribeToTopic() {
        if registrationToken != nil && connectedToGCM {
            
            GCMPubSub.sharedInstance().subscribe(withToken: self.registrationToken,
                                                 topic: subscriptionTopic,
                                                 options: nil,
                                                 handler: {
                                                    error -> Void in
                                                        if let error = error as? NSError {
                                                            // Treat the "already subscribed" error more gently
                                                            if error.code == 3001 {
                                                                NSLog("Already subscribed to \(self.subscriptionTopic)")
                                                            } else {
                                                                NSLog("Subscription failed: \(error.localizedDescription)")
                                                            }
                                                        } else {
                                                            self.subscribedToTopic = true
                                                            NSLog("Subscribed to \(self.subscriptionTopic)")
                                                        }
                                                })
        }
    }
        
    
    // [START receive_apns_token_error]
    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error ) {
        NSLog("Registration for remote notification failed with error: \(error.localizedDescription)")
        // [END receive_apns_token_error]
        let userInfo = ["error": error.localizedDescription]
        
        NotificationCenter.default.post( name: Notification.Name(rawValue: registrationKey),
                                         object: nil,
                                         userInfo: userInfo)
    }
    
    // [START ack_message_reception]
    func application( _ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        NSLog("1  Notification received: \(userInfo)")
        GCMService.sharedInstance().appDidReceiveMessage(userInfo)
        NotificationCenter.default.post(name: Notification.Name(rawValue: messageKey), object: nil,
                                        userInfo: userInfo)
        // [END_EXCLUDE]
    }
    
    func application( _ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                      fetchCompletionHandler handler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        GCMService.sharedInstance().appDidReceiveMessage(userInfo)
        NotificationCenter.default.post(name: Notification.Name(rawValue: messageKey),
                                        object: nil,
                                       userInfo: userInfo)
        
        handler(UIBackgroundFetchResult.noData)
        print (userInfo)
        var notification = [News]()
        var idPost = userInfo[AnyHashable("gcm.notification.idPost")] as! String
        if idPost.isEmpty{
            idPost = "564792"
        }
        let urlPath = ApiConstants.PropertyKey.baseURL + ""+ApiConstants.PropertyKey.listPost+"/\(idPost)"
        
        NSLog(urlPath)
        servicesConnection.loadNews(notification, urlPath: urlPath, completionHandler: {(moreWrapper, error) in
            notification = moreWrapper!
            DispatchQueue.main.async(execute: {
                
                if (notification.count>0){
                    
                    let item = PostNotification(idPost: (notification.first?.idNews)!,
                                                title: (notification.first?.titleNews)!,
                                                subTitle: (notification.first?.titleNews)! ,
                                                UUID: UUID().uuidString,
                                                imageURL: (notification.first?.imageURLNews) ?? "SinImagen",
                                                date: (notification.first?.dateNews) ?? "01-01-2017",
                                                link: (notification.first?.linkNews) ?? "www.upsocl.com",
                                                category: (notification.first?.categoryNews) ?? "Portada",
                                                author: (notification.first?.authorNews) ?? "Anonimo",
                                                content: (notification.first?.contentNews) ?? "",
                                                isRead: false)
                    
                    NewsSingleton.sharedInstance.removeAllItem(itemKey: NewsSingleton.sharedInstance.ITEMS_KEY_Notification)
                    NewsSingleton.sharedInstance.addNotification(item)
                    self.sendActivityMain()
                    
                    return
                }
                return
            })
        })
    }
    
    func googleStartConfig(_ application: UIApplication) {
        
        //Initialize sign-in Google
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configurando el servicio de Google: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self  //Login Google
        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
        
        NSLog ("gcmSenderId   ",gcmSenderID ?? "tokent")
        
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
    }
    
    
    func facebookStartConfig(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func twitterStartConfig() -> Void {
         Fabric.with([Twitter.self])
    }
    
    func googleAnalyticsStart() -> Void{
        // Configure tracker from GoogleService-Info.plist.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
      
    }
    
    func sendActivityMain() -> Void {
        
        let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signOutPage = myStroryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let signOutPageNav = UINavigationController(rootViewController: signOutPage)
        signOutPageNav.setNavigationBarHidden(signOutPageNav.isNavigationBarHidden == false, animated: true)
        
        let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController =  signOutPageNav
    }
    
    func validLoginUser() -> Bool{
        
        let user: [UserLogin] = UserSingleton.sharedInstance.getUserLogin()
        if user.first?.email.isEmpty == false {
            
            NSLog ("socialNetworkName  \(user.first?.email)  \(user.first?.socialNetwork)")
           
            self.sendActivityMain()
        }else{
            NSLog ("NO LOGIN")}

         return false
    }
    

    func isSignIn (_ application: UIApplication, open url: URL, sourceApplication: String , annotation: Any! )-> Bool {
        
        var signIn = GIDSignIn.sharedInstance().handle(url,
                                                       sourceApplication: sourceApplication,
                                                       annotation: annotation)
        
        if (signIn){ return true }
        
        signIn = FBSDKApplicationDelegate.sharedInstance().application(application, open: url,
                                                                       sourceApplication: sourceApplication,
                                                                       annotation: annotation)
        return signIn
        
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
}

