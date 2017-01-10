//
//  PreferencsViewController.swift
//  appupsocl
//
//  Created by upsocl on 28-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import TwitterKit
import Google


class PreferencsViewController: UIViewController,FBSDKLoginButtonDelegate , GIDSignInUIDelegate {
   


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
    let preferences = UserDefaults.standard
    let namePreferences = "peferencsNotification"
    var socialNetworkName: String = ""
    var socialNetworkTokenId: String = ""
    
    
    //Category
    let category = Category()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var prefe = preferences.object(forKey: namePreferences)
        if prefe == nil{
            prefe = "day"
        }
        savePreferences(prefe as! String)
        
        let fistName  = preferences.object(forKey: Customer.PropertyKey.firstName) as! String
        let lastName  = preferences.object(forKey: Customer.PropertyKey.lastName) as! String
        let email  = preferences.object(forKey: Customer.PropertyKey.email) as! String
        let location  = preferences.object(forKey: Customer.PropertyKey.location) as! String
        socialNetworkName  = (preferences.object(forKey: Customer.PropertyKey.socialNetwork) as? String)!
        socialNetworkTokenId = (preferences.object(forKey: Customer.PropertyKey.socialNetworkTokenId) as? String)!
        
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
    

    @IBAction func dayButton(_ sender: UIButton) {
        savePreferences("day")
    }
    
    @IBAction func weekButton(_ sender: UIButton) {
        savePreferences("week")
    }
    
    @IBAction func monthButton(_ sender: UIButton) {
        savePreferences("month")
    }
    
    
    func savePreferences(_ frecuency: String){
        
        switch frecuency {
        case "day":
            daySelected.setImage(checkImage, for: UIControlState())
            weekSelected.setImage(unCheckImage, for: UIControlState())
            monthSelected.setImage(unCheckImage, for: UIControlState())
        case "week":
            weekSelected.setImage(checkImage, for: UIControlState())
            daySelected.setImage(unCheckImage, for: UIControlState())
            monthSelected.setImage(unCheckImage, for: UIControlState())
        case "month":
            monthSelected.setImage(checkImage, for: UIControlState())
            daySelected.setImage(unCheckImage, for: UIControlState())
            weekSelected.setImage(unCheckImage, for: UIControlState())
        default:
            print ("no es nada")
        }
        preferences.setValue(frecuency, forKey: namePreferences )
        preferences.synchronize()
    }
    
    func closeSession(){
        print ("close")
    }
    
    @IBAction func signOutButton(_ sender: AnyObject) {
        
        // create the alert
        let alert = UIAlertController(title: "Alerta", message: "Esta seguro que desea cerrar sesión?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Si", style: UIAlertActionStyle.default, handler: { action in
            print("Click of default button")
           
            if (self.socialNetworkName=="facebook" ){
                FBSDKLoginManager().logOut()
            }
            
            
             if (self.socialNetworkName=="google" ){
             GIDSignIn.sharedInstance().signOut()
             }
             
             if (self.socialNetworkName == "twitter"){
                let store = Twitter.sharedInstance().sessionStore
                
                if let userID = store.session()?.userID {
                    store.logOutUserID(userID)
                }
                Twitter.sharedInstance().sessionStore.logOutUserID(self.socialNetworkTokenId)
            }
            
            self.clearPreferences()
            self.category.clearCategoryPreference()
            
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginUserController") as! LoginUserController
            let signInPageNav =  UINavigationController(rootViewController: signInPage)
            let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController =  signInPageNav
            
            }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { action in
            print("Click of default button")
            }
        ))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    func login (text: UITextField){
        print ("Login ")
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print ("lFBSDKLoginButton - LoginButtonDidLogOut")
    }
    
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("LogOutButton Facebook")
    }
 
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func clearPreferences(){
        
        let preferences = UserDefaults.standard
        preferences.removeObject(forKey: Customer.PropertyKey.email)
        preferences.removeObject(forKey: Customer.PropertyKey.firstName )
        preferences.removeObject(forKey: Customer.PropertyKey.lastName)
        preferences.removeObject(forKey: Customer.PropertyKey.imagenURL)
        preferences.removeObject(forKey: Customer.PropertyKey.userId) //-------------FIXME
        preferences.removeObject(forKey: Customer.PropertyKey.socialNetwork)
        preferences.removeObject(forKey: Customer.PropertyKey.socialNetworkTokenId)
        //preferences.setValue(birthday, forKey: Customer.PropertyKey.birthday )
        //preferences.setValue(tocken, forKey: Customer.PropertyKey.token)
        
        for elem in UserDefaults.standard.dictionaryRepresentation(){
            let key = elem.0
            
            let numberCharacters = CharacterSet.decimalDigits.inverted
            if !key.isEmpty && key.rangeOfCharacter(from: numberCharacters) == nil{
                print (key)
                preferences.removeObject(forKey: key)
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
