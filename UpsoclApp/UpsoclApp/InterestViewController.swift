//
//  PhotoViewController.swift
//  UpsoclApp
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class InterestViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let categoryCount = countCategory()
        if categoryCount < 3 {
            menuButton.enabled =  false
        }else{
            enableMenu()
        }
    }
    
    func enableMenu(){
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
    @IBAction func aceptarButton(sender: UIButton) {

        let categoryCount = countCategory()
        if categoryCount < 3 {
            menuButton.enabled =  false
            
            createViewMessage("Debe seleccionar al menos 3 categorias")
            self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }else{
            enableMenu()
            menuButton.enabled =  true
            createViewMessage("Caterias modificadas con éxito..!")
        }
    }
    
    
    func createViewMessage(message: String){
        let alertView = UIAlertView(title: "Mensaje", message: message, delegate: self, cancelButtonTitle: "Aceptar")
        alertView.tag = 1
        alertView.show()
    }
    func countCategory() -> Int {
        
        var categoryCount = 0
        for elem in NSUserDefaults.standardUserDefaults().dictionaryRepresentation(){
            
            let key = elem.0
            
            switch key {
            case "culture":
                categoryCount += 1
            case "beauty":
                categoryCount += 1
            case "colaboration":
                categoryCount += 1
            case "community":
                categoryCount += 1
            case "creativity":
                categoryCount += 1
            case "diversity":
                categoryCount += 1
            case "family":
                categoryCount += 1
            case "food":
                categoryCount += 1
            case "green":
                categoryCount += 1
            case "health":
                categoryCount += 1
            case "inspiration":
                categoryCount += 1
            case "movies":
                categoryCount += 1
            case "populary":
                categoryCount += 1
            case "quiz":
                categoryCount += 1
            case "relations":
                categoryCount += 1
            case "stileLive":
                categoryCount += 1
            case "women":
                categoryCount += 1
            case "world":
                categoryCount += 1
            default:
                0
            }
        }
        return categoryCount
    }
}
