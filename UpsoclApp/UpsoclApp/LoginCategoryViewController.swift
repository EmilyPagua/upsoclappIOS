//
//  LoginUserViewController.swift
//  appupsocl
//
//  Created by upsocl on 10-03-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class LoginCategoryViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    var category = Category()
    var beforeCategory = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validCountCategory(_ sender: UIButton) {
        countCategory ()
    }
    
    func countCategory (){
        
        let categoryCount = category.countCategory()
        if categoryCount <= 1 || beforeCategory <= 1  {
            self.nextButton.isHidden = true
            
        } else {
            self.nextButton.isHidden = false
        }
        
        beforeCategory = categoryCount
    }
    @IBAction func nextButton(_ sender: UIButton) {
        let categoryCount = category.countCategory()
        if categoryCount < 2 {
            MessageAlert.sharedInstance.createViewMessage("Debe seleccionar al menos 3 categorias", title: "Mensaje")
        }else{
            MessageAlert.sharedInstance.createViewMessage("Categorias savadas con éxito..!", title: "Mensaje")
            
        }
    }
}
