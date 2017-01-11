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
    
    
}
