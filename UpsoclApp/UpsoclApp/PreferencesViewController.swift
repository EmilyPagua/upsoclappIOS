//
//  PreferencesViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 20-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //Var user
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var emailUserLabel: UILabel!
    @IBOutlet weak var locationUSerLabel: UILabel!
    
    
    //button of preferences notification
    @IBOutlet weak var daySelected: UIButton!
    @IBOutlet weak var weekSelected: UIButton!
    @IBOutlet weak var monthSelected: UIButton!
    
    @IBOutlet weak var cerrarSession: UIButton!
    
    //Imagen of button
    let checkImage = UIImage(named: "radioButtonActive")! as UIImage
    let unCheckImage = UIImage(named: "radioButtonInactive")! as UIImage
    
    //Get preferences or notifications
    let preferences = NSUserDefaults.standardUserDefaults()
    let namePreferences = "peferencsNotification"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var prefe = preferences.objectForKey(namePreferences)
        if prefe == nil{
            prefe = "day"
        }
        savePreferences(prefe as! String)
        
        let fistName  = preferences.objectForKey(Customer.PropertyKey.firstName) as! String
        let lastName  = preferences.objectForKey(Customer.PropertyKey.lastName) as! String
        let email  = preferences.objectForKey(Customer.PropertyKey.email) as! String
        let location  = preferences.objectForKey(Customer.PropertyKey.location) as! String
        
        nameUserLabel.text = "Usuario: " + fistName + " " + String(lastName)
        emailUserLabel.text = "Email: " + email
        locationUSerLabel.text = "Ubicación: " + location
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //controller buttonMenu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
        
        GIDSignIn.sharedInstance().signOut()
        
        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("LoginUserController") as! LoginUserController
        
        let signInPageNav =  UINavigationController(rootViewController: signInPage)
        
        let appDelegate: AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController =  signInPageNav
        
        print ("signOutButton")
    }

    
}
