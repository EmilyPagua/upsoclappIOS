//
//  SignOutViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 27-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SignOutViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signOutButton(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginUserController") as! LoginUserController
        
        let signInPageNav =  UINavigationController(rootViewController: signInPage)
        
        let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController =  signInPageNav
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
