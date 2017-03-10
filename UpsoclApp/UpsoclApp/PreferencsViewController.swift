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
    @IBOutlet weak var sessionUser: UIButton!
    
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
    var isLogin:Bool =  false
    var user: [UserLogin] = UserSingleton.sharedInstance.getUserLogin()

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
        
       
        if (user.first?.isLogin)! {
        
            let fistName  = user.first?.firstName
            let lastName  = user.first?.lastName
            let email  = user.first?.email
            let location  = user.first?.location
            socialNetworkName  =  (user.first?.socialNetwork)!
            socialNetworkTokenId =  (user.first?.socialNetworkTokenId)!
            
            self.loadDataUser(usuario: "\(fistName!)  \(lastName!)",
                            email: email!,
                            location: location!,
                            sn: socialNetworkName)
            self.isLogin = true
        }
        else{
            self.loadDataUser(usuario: "--", email: "--", location: "--", sn: "--")
            
            self.sessionUser.setTitle("Iniciar sesión", for: .normal)
        }
    
        GIDSignIn.sharedInstance().uiDelegate = self
        
        loginButtonFacebook.delegate = self
        
        //controller buttonMenu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func loadDataUser(usuario: String, email: String, location: String, sn: String){
        
        nameUserLabel.text = "Usuario: " + usuario
        emailUserLabel.text = "Email: " +  email
        locationUSerLabel.text = "Ubicación: " + location
        socialNetwork.text = "Red social: " + sn
    
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
            NSLog ("Nil option")
        }
        preferences.setValue(frecuency, forKey: namePreferences )
        preferences.synchronize()
    }

    
    @IBAction func signOutButton(_ sender: AnyObject) {
        self.user = UserSingleton.sharedInstance.getUserLogin()
        
        if (self.user.first?.isLogin == false ) {
            StroyBoardView.sharedInstance.login(item: nil)
        }
        
        // create the alert
        let alert = UIAlertController(title: "Alerta", message: "Esta seguro que desea cerrar sesión?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Si", style: UIAlertActionStyle.default, handler: { action in
            NSLog("Click of default button")
           
            self.sessionUser.setTitle("Iniciar sesión", for: .normal)
            
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
            
            UserSingleton.sharedInstance.removeUseLogin()
            
            let userLogin  =  UserLogin(email: "",
                                        firstName: "",
                                        lastName:  "",
                                        location : "--" ,
                                        birthday: "00-00-0000" ,
                                        imagenURL: URL(string: ".")!,
                                        token: "",
                                        userId: "",
                                        socialNetwork: "" ,
                                        socialNetworkTokenId: "",
                                        registrationId: "",
                                        isLogin : false as Bool)

            UserSingleton.sharedInstance.addUser(userLogin)
            NewsSingleton.sharedInstance.removeAllItem(itemKey: NewsSingleton.sharedInstance.ITEMS_KEY_BOOKMARK)
            
            self.loadDataUser(usuario: "--", email: "--", location: "--", sn: "--")

            StroyBoardView.sharedInstance.goMenu()
            
            }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { action in
            NSLog("Click of default button")
            }
        ))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

 
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        NSLog ("lFBSDKLoginButton - LoginButtonDidLogOut")
    }

    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        NSLog("LogOutButton Facebook")
    }
 
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    

}
