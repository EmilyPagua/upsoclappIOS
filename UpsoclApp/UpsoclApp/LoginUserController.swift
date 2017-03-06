//
//  LoginUserController.swift
//  appupsocl
//
//  Created by upsocl on 26-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import Google

class LoginUserController: UIViewController, GIDSignInUIDelegate , FBSDKLoginButtonDelegate {
    
     @IBOutlet weak var loginButtonTwitter: UIButton!
    // [START viewcontroller Google]
    @IBOutlet weak var signInButtonGoogle: GIDSignInButton!
    // [END viewcontroller Google]
    
    // [START viewcontroller Facebook]
    @IBOutlet weak var loginButtonFacebook: FBSDKLoginButton?  = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    // [END viewcontroller Facebook]
    
    var category = Category()
    var beforeCategory = 0
    let servicesConnection  = ServicesConnection()

    var progressView: UIProgressView?
    var progressLabel: UILabel?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customButtonLogin()
        self.countCategory ()
    
        let user: [UserLogin] = UserSingleton.sharedInstance.getUserLogin()
        NSLog("user.email  \(user.first?.email)")
        if user.first?.email.isEmpty == false {
            NSLog ("LOGIN \(user.first?.email)")
        }else{
            NSLog ("NO LOGIN")
            GIDSignIn.sharedInstance().uiDelegate = self  //Start GoogleLogin
            self.loginButtonFacebook!.delegate = self  //Start FacebookLogin
        }
    }
    
    func customButtonLogin(){
    
        let layoutConstraintsArr = self.loginButtonFacebook?.constraints
        for lc in layoutConstraintsArr! { 
            if ( lc.constant == 28 ){
                lc.isActive = false
                break
            }
        }
    }
    
    func updateProgress() {
        progressView?.progress += 0.05
        let progressValue = self.progressView?.progress
        progressLabel?.text = "\(progressValue! * 100) %"
    }
    //End progressBar
    
    @IBAction func validarLogin(_ sender: AnyObject) {
        
        // If using the log in methods on the Twitter instance
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
                NSLog(" session!.userName  \(session!.userName)");
                Twitter.sharedInstance().sessionStore.logOutUserID((session?.authToken)!)
                
                
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
                        
                        //print(json)
                        let imagenUserURL =  json["profile_image_url"] as! String
                        NSLog (imagenUserURL)
                        
                        let userLogin  =  UserLogin(email: "",
                                                    firstName: json["name"] as! String,
                                                    lastName:  "",
                                                    location : "--" ,
                                                    birthday: "00-00-0000" ,
                                                    imagenURL: URL(string: imagenUserURL)!,
                                                    token: "qwedsazxc2",
                                                    userId: "112233",
                                                    socialNetwork: "twitter" as String,
                                                    socialNetworkTokenId: "tokentTwitter",
                                                    registrationId: "tokentWordpress" )
                        
                        
                        if (userLogin.email.isEmpty) {
                            self.validEmailUser(userLogin: userLogin)
                        }
                        else{
                            self.saveUser(userLogin: userLogin)
                            self.sendActivityMain()
                        }
                        
                    }catch let error as NSError{
                        NSLog ("ERROR_:   \(error.localizedDescription)")
                        json = nil
                        return
                    }
                }
            } else {
                NSLog("ERROR_: \(error!.localizedDescription)");
            }
        }
    }
    
    @IBAction func validCountCategory(_ sender: UIButton) {
        countCategory ()
    }
    
    func saveUser(userLogin: UserLogin ) -> Void {
        UserSingleton.sharedInstance.removeUseLogin()
        UserSingleton.sharedInstance.addUser(userLogin)
    }
    
    func countCategory (){
        
        let categoryCount = category.countCategory()
        //NSLog ("Category:  \(categoryCount)")
        if categoryCount <= 1 || beforeCategory <= 1  {
            self.loginButtonFacebook?.isEnabled = false
            self.signInButtonGoogle?.isEnabled = false
            self.loginButtonTwitter?.isEnabled = false
        } else {
            self.loginButtonFacebook?.isEnabled = true
            self.signInButtonGoogle?.isEnabled = true
            self.loginButtonTwitter?.isEnabled = true
        }
        
        beforeCategory = categoryCount
    }
    
    // [------------------------START GOOGLE LOGIN-------------------]
    @IBAction func loginButtonGoogle(_ sender: UIButton) {
        let categoryCount = category.countCategory()
        if categoryCount < 3 {
            MessageAlert.sharedInstance.createViewMessage("Debe seleccionar al menos 3 categorias", title: "Mensaje")
        }else{
            MessageAlert.sharedInstance.createViewMessage("Categorias modificadas con éxito..!", title: "Mensaje")
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
                NSLog ("Google status: " + String(describing: userInfo["statusText"]))
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
        
        NSLog ("Google Login presented")
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
                dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
        NSLog ("Google Login dismissed")
    }
    
    // [------------------------FINISH GOOGLE LOGIN-------------------]

    // [------------------------START FACEBOOK LOGIN-------------------]
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        NSLog ("FBSDKLoginButton Completado Login")
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        NSLog ("FBSDKLoginButton - LoginButtonDidLogOut")

    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, user, requestError) -> Void in
            
            if requestError != nil {
                NSLog("ERROR_ "+(requestError?.localizedDescription)!)
                return
            }
            
            let data_block = user as? [String: AnyObject]
            
            let email  = data_block?["email"] as! String?
            let firstName = data_block?["first_name"] as? String
            let lastName = data_block?["last_name"] as? String
            
            NSLog ("Usuario email: \(email)")

            
            var pictureUrl = "firstName:  " + String(describing: firstName)
            if let picture = data_block?["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                pictureUrl = url
            }
            
            let url = URL(string: pictureUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    NSLog("ERROR_ "+(error?.localizedDescription)!)
                    return
                }
            }).resume()
            let userLogin  =  UserLogin(email: email!,
                                        firstName: firstName!,
                                        lastName: lastName!,
                                        location: "--",
                                        birthday: "00-00-0000",
                                        imagenURL: URL(string: pictureUrl)!,
                                        token: "qwedsazxc2",
                                        userId: "0",
                                        socialNetwork: "facebook",
                                        socialNetworkTokenId: "tokentFacebook",
                                        registrationId: "tokentWordpress" )
            
            UserSingleton.sharedInstance.removeUseLogin()
            UserSingleton.sharedInstance.addUser(userLogin)
            
            self.sendActivityMain()
            
            
        })
    }
     // [------------------------FINISH FACEBOOK LOGIN-------------------]
    
    func validEmailUser(userLogin: UserLogin){
        
        let alertController = UIAlertController(title: "Faltan datos en su pertfil", message: "Por favor, ingrese su email personal", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Guardar", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            if emailPredicate.evaluate(with: textField.text){
                let mail = textField.text!
                
                let userLogin  =  UserLogin(email: mail,
                                            firstName: userLogin.firstName,
                                            lastName: userLogin.lastName,
                                            location: userLogin.location,
                                            birthday: userLogin.birthday,
                                            imagenURL: userLogin.imagenURL,
                                            token: userLogin.token,
                                            userId:userLogin.userId,
                                            socialNetwork: userLogin.socialNetwork,
                                            socialNetworkTokenId: userLogin.socialNetworkTokenId,
                                            registrationId: userLogin.registrationId )
                
                self.saveUser(userLogin: userLogin)
                self.sendActivityMain()
                
            }else{
                NSLog("ERROR_ validarLogin No es válido")
            }
        }))
        
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Search"
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendActivityMain() -> Void {
        
        let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signOutPage = myStroryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let signOutPageNav = UINavigationController(rootViewController: signOutPage)
        signOutPageNav.setNavigationBarHidden(signOutPageNav.isNavigationBarHidden == false, animated: true)
        let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController =  signOutPageNav
    }
    
}
