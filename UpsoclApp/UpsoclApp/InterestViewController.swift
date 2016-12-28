//
//  PhotoViewController.swift
//  appupsocl
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class InterestViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var category =  Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let categoryCount = category.countCategory()
        if categoryCount < 3 {
            menuButton.isEnabled =  false
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
    @IBAction func aceptarButton(_ sender: UIButton) {

        let categoryCount = category.countCategory()
        if categoryCount < 3 {
            menuButton.isEnabled =  false
            
            createViewMessage("Debe seleccionar al menos 3 categorias")
            self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }else{
            enableMenu()
            menuButton.isEnabled =  true
            createViewMessage("Categorías modificadas con éxito..!")
        }
    }
    
    func createViewMessage(_ message: String){
        let alertView = UIAlertView(title: "Mensaje", message: message, delegate: self, cancelButtonTitle: "Aceptar")
        alertView.tag = 1
        alertView.show()
    }
}
