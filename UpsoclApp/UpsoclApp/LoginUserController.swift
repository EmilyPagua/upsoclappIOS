//
//  LoginUserContr.swift
//  UpsoclApp
//
//  Created by upsocl on 26-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class LoginUserController: UIViewController {
    
    var category = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButton(sender: UIButton) {
        let categoryCount = category.countCategory()
        if categoryCount < 3 {
            createViewMessage("Debe seleccionar al menos 3 categorias")
        }else{
            //createViewMessage("Caterias modificadas con éxito..!")
        }
        
    }
    
    func createViewMessage(message: String){
        let alertView = UIAlertView(title: "Mensaje", message: message, delegate: self, cancelButtonTitle: "Aceptar")
        alertView.tag = 1
        alertView.show()
    }
    
}
