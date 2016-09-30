//
//  PreferencsViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 28-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import TwitterKit


class PreferencsViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate  {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //Var user
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var emailUserLabel: UILabel!
    @IBOutlet weak var locationUSerLabel: UILabel!
    @IBOutlet weak var socialNetwork: UILabel!
    
    
    //button of preferences notification
    @IBOutlet weak var daySelected: UIButton!
    @IBOutlet weak var weekSelected: UIButton!
    @IBOutlet weak var monthSelected: UIButton!
    @IBOutlet weak var cerrarSession: UIButton!
    
    //Imagen of button
    let checkImage = UIImage(named: "radioButtonActive")! as UIImage
    let unCheckImage = UIImage(named: "radioButtonInactive")! as UIImage
    
    // [START viewcontroller Facebook]
    let loginButtonFacebook: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    // [END viewcontroller Facebook]
    
    //Get preferences or notifications
    let preferences = NSUserDefaults.standardUserDefaults()
    let namePreferences = "peferencsNotification"
    var socialNetworkName: String = ""
    var socialNetworkTokenId: String = ""
    
    
    //Category
    let category = Category()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var prefe = preferences.objectForKey(namePreferences)
        if prefe == nil{
            prefe = "day"
        }
        savePreferences(prefe as! String)
        
        let fistName  = preferences.objectForKey(Customer.PropertyKey.firstName) as! String
        let lastName  = preferences.objectForKey(Customer.PropertyKey.lastName) as! String
        let email  = preferences.objectForKey(Customer.PropertyKey.email) as! String
        let location  = preferences.objectForKey(Customer.PropertyKey.location) as! String
        socialNetworkName  = (preferences.objectForKey(Customer.PropertyKey.socialNetwork) as? String)!
        socialNetworkTokenId = (preferences.objectForKey(Customer.PropertyKey.socialNetworkTokenId) as? String)!
        
        nameUserLabel.text = "Usuario: " + fistName + " " + String(lastName)
        emailUserLabel.text = "Email: " + email
        locationUSerLabel.text = "Ubicación: " + location
        socialNetwork.text = "Red social: " + socialNetworkName
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        loginButtonFacebook.delegate = self
        
        //controller buttonMenu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dayButton(sender: UIButton) {
        savePreferences("day")
    }
    
    @IBAction func weekButton(sender: UIButton) {
        savePreferences("week")
    }
    
    @IBAction func monthButton(sender: UIButton) {
        savePreferences("month")
    }
    
    
    func savePreferences(frecuency: String){
        
        switch frecuency {
        case "day":
            daySelected.setImage(checkImage, forState: .Normal)
            weekSelected.setImage(unCheckImage, forState: .Normal)
            monthSelected.setImage(unCheckImage, forState: .Normal)
        case "week":
            weekSelected.setImage(checkImage, forState: .Normal)
            daySelected.setImage(unCheckImage, forState: .Normal)
            monthSelected.setImage(unCheckImage, forState: .Normal)
        case "month":
            monthSelected.setImage(checkImage, forState: .Normal)
            daySelected.setImage(unCheckImage, forState: .Normal)
            weekSelected.setImage(unCheckImage, forState: .Normal)
        default:
            print ("no es nada")
        }
        preferences.setValue(frecuency, forKey: namePreferences )
        preferences.synchronize()
    }
    
    
    @IBAction func signOutButton(sender: AnyObject) {
        
        if (socialNetworkName=="google" ){
            GIDSignIn.sharedInstance().signOut()
            print ("Google - signOutButton")
        }
        if (socialNetworkName=="facebook" ){
            print ("Facebook - signOutButton")
            FBSDKLoginManager().logOut()
        }
        
        if (socialNetworkName == "twitter"){
            print ("Twitter - signOutButton")
            Twitter.sharedInstance().sessionStore.logOutUserID(socialNetworkTokenId)
        }
        
        clearPreferences()
        category.clearCategoryPreference()
        
        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("LoginUserController") as! LoginUserController
        let signInPageNav =  UINavigationController(rootViewController: signInPage)
        let appDelegate: AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController =  signInPageNav
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print ("lFBSDKLoginButton - LoginButtonDidLogOut")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("LogOutButton Facebook")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func clearPreferences(){
        
        let preferences = NSUserDefaults.standardUserDefaults()
        preferences.removeObjectForKey(Customer.PropertyKey.email)
        preferences.removeObjectForKey(Customer.PropertyKey.firstName )
        preferences.removeObjectForKey(Customer.PropertyKey.lastName)
        preferences.removeObjectForKey(Customer.PropertyKey.imagenURL)
        preferences.removeObjectForKey(Customer.PropertyKey.userId) //-------------FIXME
        preferences.removeObjectForKey(Customer.PropertyKey.socialNetwork)
        preferences.removeObjectForKey(Customer.PropertyKey.socialNetworkTokenId)
        //preferences.setValue(birthday, forKey: Customer.PropertyKey.birthday )
        //preferences.setValue(tocken, forKey: Customer.PropertyKey.token)
        
        for elem in NSUserDefaults.standardUserDefaults().dictionaryRepresentation(){
            let key = elem.0
            
            let numberCharacters = NSCharacterSet.decimalDigitCharacterSet().invertedSet
            if !key.isEmpty && key.rangeOfCharacterFromSet(numberCharacters) == nil{
                print (key)
                preferences.removeObjectForKey(key)
            }
        }
        
        preferences.synchronize()
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
