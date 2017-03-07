//
//  MessageAlert.swift
//  appupsocl
//
//  Created by upsocl on 11-01-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class MessageAlert {
    class var sharedInstance : MessageAlert {
        struct Static {
            static let instance: MessageAlert = MessageAlert()
        }
        return Static.instance
    }
    
    func createViewMessage(_ message: String, title: String ){
        let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Aceptar")
        alertView.tag = 1
        alertView.show()
    }
    
    func loadImage(_ urlImage: String?, viewImagen: UIImageView, indicator: UIActivityIndicatorView){
        
        self.loadImage(urlImage: urlImage!, completionHandler: { (moreWrapper, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                viewImagen.image = moreWrapper
                indicator.stopAnimating()
            })
        })
    }
    
    
    func loadImage(urlImage: String, completionHandler: @escaping (UIImage, NSError?) -> Void ){
        
        if (urlImage.isEmpty) {
            completionHandler(UIImage(named: "webkit-featured")!, nil)
            
        }else{
            let imgURL = URL(string: urlImage as String)
            if imgURL != nil {
                let task = URLSession.shared.dataTask(with: imgURL!, completionHandler: { (responseData, responseUrl, error) -> Void in
                    
                    if let data = responseData{
                        print ("data \(data)")
                        completionHandler(UIImage(data: data)!, nil)
                    }else{
                        NSLog ("data = null")
                    }
                })
                // Run task
                task.resume()
            }else {
                completionHandler(UIImage(named: "webkit-featured")!, nil)
            }
        }
    }
    
}
