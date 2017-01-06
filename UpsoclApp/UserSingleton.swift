//
//  CustomerSingleton.swift
//  appupsocl
//
//  Created by upsocl on 06-01-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class CustomerSingleton {
    class var sharedInstance : CustomerSingleton {
        struct Static {
            static let instance: CustomerSingleton = CustomerSingleton()
        }
        return Static.instance
    }
    
    var ITEMS_KEY = "userLogin"
    
    /*func adUser(_ item: Customer ){
        
        //var userLogin = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
        
       // userLogin[item.] = ["idPost": item.idPost, "title": item.title, "subTitle": item.subTitle , "UUID": item.UUID]
    }
    
    */
    
}
