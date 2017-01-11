//
//  Customer.swift
//  appupsocl
//
//  Created by upsocl on 27-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class Customer: NSObject{// NSCoding{
    
    var firstName: String
    var lastName: String
    var email : String
    var location : String
    var birthday : String
    var imagenURL : URL
    var token : String
    var userId : String
    var socialNetwork : String
    var socialNetworkTokenId : String
    var registrationId : String
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("customerKey")

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
        static let registrationId = "registration_id"
    }
    
    init? (firstName: String, lastName:String, email: String, location: String, birthday: String, imagenURL: URL, token: String, userId: String,socialNetwork:String, socialNetworkTokenId:String, registrationId:String ){
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.location = location
        self.birthday = birthday
        self.imagenURL = imagenURL
        self.token = token
        self.userId =  userId
        self.socialNetwork = socialNetwork
        self.socialNetworkTokenId =  socialNetworkTokenId
        self.registrationId = registrationId
        
        super.init()
    }
}



