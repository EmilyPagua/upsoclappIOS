//
//  MenuController.swift
//  appupsocl
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {

    @IBOutlet weak var imagenUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    var servicesConnection =  ServicesConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("viewDidLoad - MenuController")

        let user: [UserLogin] = UserSingleton.sharedInstance.getUserLogin()
        
        let imagenURL  = (user.first?.imagenURL.absoluteString)!
        let firstName = user.first?.firstName
        let lastName = user.first?.lastName
        
        nameUser.text  = String ( lastName! + "  " + firstName!)
                
        self.loadImage(imagenURL, viewImagen: imagenUser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print ("didReceiveMemoryWarning - MenuController")
    }


    func loadImage(_ urlImage: String?, viewImagen: UIImageView){
        
        servicesConnection.loadImage(urlImage: urlImage as String!, completionHandler: { (moreWrapper, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                viewImagen.image = moreWrapper
                viewImagen.layer.frame = self.imagenUser!.layer.frame.insetBy(dx: 0, dy: 0)
                viewImagen.layer.borderColor = UIColor.white.cgColor
                viewImagen.layer.cornerRadius = self.imagenUser!.frame.height/2
                viewImagen.layer.masksToBounds = false
                viewImagen.clipsToBounds = true
                viewImagen.layer.borderWidth = 1
                viewImagen.contentMode = UIViewContentMode.scaleAspectFit
            })
        })
    }

}
