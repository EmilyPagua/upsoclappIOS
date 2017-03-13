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
import FBSDKCoreKit
import Bolts

class LoginUserController: UIViewController, GIDSignInUIDelegate , FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
   
    @IBOutlet weak var messageLabel: UILabel!
    
     @IBOutlet weak var loginButtonTwitter: UIButton!
    // [START viewcontroller Google]
    @IBOutlet weak var signInButtonGoogle: GIDSignInButton!
    // [END viewcontroller Google]
    
    var postNotification: PostNotification? = nil
    var isBookmark =  false
    var isGoogleClick : Bool? = false
    
    // [START viewcontroller Facebook]
    let parametersFacebook = ["fields": "email, first_name, last_name, picture.type(large)"]
    
    @IBOutlet weak var loginButtonFacebook: FBSDKLoginButton?  = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile","email"]
        return button
    }()
    // [END viewcontroller Facebook]

    
    let servicesConnection  = ServicesConnection()

    var progressView: UIProgressView?
    var progressLabel: UILabel?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.logout()
        self.showAnimate()
        
        self.customButtonLogin()
        self.configureButton()
        
        self.tabBarController?.tabBar.isHidden =  true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func logout(){
        
        let user: [UserLogin] = UserSingleton.sharedInstance.getUserLogin()
        let LoginManager :  FBSDKLoginManager =  FBSDKLoginManager()
        LoginManager.logOut()
        FBSDKLoginManager().logOut()
        
        if (user.first?.email != nil) {
            Twitter.sharedInstance().sessionStore.logOutUserID((user.first?.registrationId)!)
        }
    }
    
    func configureButton() -> Void {
        GIDSignIn.sharedInstance().uiDelegate = self  //Start GoogleLogin
        self.loginButtonFacebook!.delegate = self  //Start FacebookLogin
        
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
    
    @IBAction func validarLogin(_ sender: AnyObject) {
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
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
                        
                        let imagenUserURL =  json["profile_image_url"] as! String
                        
                        let userLogin  =  UserLogin(email: "",
                                                    firstName: json["name"] as! String,
                                                    lastName:  "",
                                                    location : UserSingleton.sharedInstance.getLocationPhone() ,
                                                    birthday: "00-00-0000" ,
                                                    imagenURL: URL(string: imagenUserURL)!,
                                                    token: "qwedsazxc2",
                                                    userId: "0",
                                                    socialNetwork: "twitter" as String,
                                                    socialNetworkTokenId: "tokentTwitter",
                                                    registrationId: "tokentWordpress",
                                                    isLogin : true as Bool)
                        
                        
                        self.validEmailUser(userLogin: userLogin)
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
    
    func saveUser(userLogin: UserLogin ) -> Void {
        
        UserSingleton.sharedInstance.removeUseLogin()
        UserSingleton.sharedInstance.addUser(userLogin)
        
        if ( userLogin.isLogin){
            self.saveBookmark()
        }
        
        self.removeAnimate()
        
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        
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
                                    registrationId: "--",
                                    isLogin : true as Bool)

       self.saveUser(userLogin: userLogin)
    }
    
    
    // [------------------------START GOOGLE LOGIN-------------------]
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
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
        print ("LoginButton Google")
        
      //  self.saveBookmark()
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
        
        if error != nil {
            NSLog("ERROR_ "+(error?.localizedDescription)!)
            return
        }else if result.isCancelled{
             NSLog("Is Cancelled ")
            return
        }else{
            NSLog("Do work \(result.description)")
            
            FBSDKGraphRequest(graphPath: "me", parameters: parametersFacebook).start(completionHandler: { (connection, user, requestError) -> Void in
                
                if requestError != nil {
                    NSLog("ERROR_ "+(requestError?.localizedDescription)!)
                    return
                }
                
                if (user == nil){
                    self.loginButtonDidLogOut(loginButton)
                    return
                }
                let data_block = user as? [String: AnyObject]
                
                var email  = data_block?["email"] as! String?
                
                if (email == nil) {
                    email = ""
                }
                
                let firstName = data_block?["first_name"] as? String
                let lastName = data_block?["last_name"] as? String
                
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
                                            location: UserSingleton.sharedInstance.getLocationPhone(),
                                            birthday: "00-00-0000",
                                            imagenURL: URL(string: pictureUrl)!,
                                            token: "qwedsazxc2",
                                            userId: "0",
                                            socialNetwork: "facebook",
                                            socialNetworkTokenId: "tokentFacebook",
                                            registrationId: "tokentWordpress",
                                            isLogin: true)
                
                self.validEmailUser(userLogin: userLogin)
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
     // [------------------------FINISH FACEBOOK LOGIN-------------------]
    
    func validEmailUser(userLogin: UserLogin) {
        
        if (userLogin.email.isEmpty) {
            
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
                                                userId: userLogin.userId,
                                                socialNetwork: userLogin.socialNetwork,
                                                socialNetworkTokenId: userLogin.socialNetworkTokenId,
                                                registrationId: userLogin.registrationId,
                                                isLogin :  true)
                    
                    self.saveUser(userLogin: userLogin)
                    
                }else{
                    
                    let loginManager: FBSDKLoginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    
                    MessageAlert.sharedInstance.createViewMessage("Error", title: "El email no es válido")
                }
            }))
            
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "Search"
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.saveUser(userLogin: userLogin)
        }
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: {(finished : Bool) in
            if (finished ){
                self.view.removeFromSuperview()
            }
        })
    }
    
    @IBAction func isClickGoogle(_ sender: GIDSignInButton) {
        
        self.isGoogleClick = true
    }
    
    func saveBookmark() -> Void {
        
        if (self.isBookmark){
            NewsSingleton.sharedInstance.addBookmark(self.postNotification!)
        }
        
        if (!self.isGoogleClick!){
            StroyBoardView.sharedInstance.goMenu()
        }
    }
    
    
}
