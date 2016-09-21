//
//  PreferencesViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 20-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit


class PreferencesViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //button of preferences notification
    @IBOutlet weak var daySelected: UIButton!
    @IBOutlet weak var weekSelected: UIButton!
    @IBOutlet weak var monthSelected: UIButton!
    
    //Imagen of button
    let checkImage = UIImage(named: "radioButtonActive")! as UIImage
    let unCheckImage = UIImage(named: "radioButtonInactive")! as UIImage
    
    //Get preferences or notifications
    let preferences = NSUserDefaults.standardUserDefaults()
    let namePreferences = "peferencsNotification"
    
    @IBAction func dayButton(sender: UIButton) {
        savePreferences("day")
    }
    
    @IBAction func weekButton(sender: UIButton) {
        savePreferences("week")
    }
    
    @IBAction func monthButton(sender: UIButton) {
        savePreferences("month")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //controller buttonMenu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        var prefe = preferences.objectForKey(namePreferences)
        if prefe == nil{
            prefe = "day"
        }
        savePreferences(prefe as! String)
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
}
