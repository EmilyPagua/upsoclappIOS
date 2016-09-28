//
//  Customer.swift
//  UpsoclApp
//
//  Created by upsocl on 27-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class Customer {
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("customerKey")

    struct PropertyKey {
        
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let location = "location"
        static let birthday =  "birthday"
        static let imagenURL = "imagenURL"
        static let token =  "token"
        static let userId = "idWP"
        static let socialNetwork = "socialNetwork"
        static let socialNetworkTokenId = "socialNetworkTokenId"
    }
}