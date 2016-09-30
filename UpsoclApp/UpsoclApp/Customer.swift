//
//  Customer.swift
//  UpsoclApp
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
    var imagenURL : String
    var token : String
    var userId : String
    var socialNetwork : String
    var socialNetworkTokenId : String
    var registrationId : String
    
    
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
        static let registrationId = "registration_id"
    }
    
    init? (firstName: String, lastName:String, email: String, location: String, birthday: String, imagenURL: String, token: String, userId: String,socialNetwork:String, socialNetworkTokenId:String, registrationId:String ){
        
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
    
    /*func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(userId, forKey: PropertyKey.userId)
        aCoder.encodeObject(firstName, forKey: PropertyKey.firstName)
        aCoder.encodeObject(lastName, forKey: PropertyKey.lastName)
        aCoder.encodeObject(email, forKey: PropertyKey.email)
        aCoder.encodeObject(location, forKey: PropertyKey.location)
        aCoder.encodeObject(imagenURL, forKey: PropertyKey.imagenURL)
        aCoder.encodeObject(token, forKey: PropertyKey.token)
        aCoder.encodeObject(socialNetworkTokenId, forKey: PropertyKey.socialNetworkTokenId)
        aCoder.encodeObject(socialNetwork, forKey: PropertyKey.socialNetwork)
        aCoder.encodeObject(registrationId, forKey: PropertyKey.registrationId)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let  firstName   = aDecoder.decodeObjectForKey(PropertyKey.firstName) as! String
        let  lastName = aDecoder.decodeObjectForKey(PropertyKey.lastName) as! String
        let  email = aDecoder.decodeObjectForKey(PropertyKey.email) as! String
        let  location = aDecoder.decodeObjectForKey(PropertyKey.location) as! String
        let  birthday = aDecoder.decodeObjectForKey(PropertyKey.birthday) as! String
        let  imagenURL = aDecoder.decodeObjectForKey(PropertyKey.imagenURL) as! String
        let  token = aDecoder.decodeObjectForKey(PropertyKey.token) as! String
        let  userId =  aDecoder.decodeObjectForKey(PropertyKey.userId) as! String
        let  socialNetwork = aDecoder.decodeObjectForKey(PropertyKey.socialNetwork) as! String
        let  socialNetworkTokenId =  aDecoder.decodeObjectForKey(PropertyKey.socialNetwork) as! String
        let  registrationId = aDecoder.decodeObjectForKey(PropertyKey.registrationId) as! String
        
        // Must call designated initializer.
        self.init(firstName: firstName,lastName: lastName,email: email,locatio: location,birthday: birthday,token: token,userId: userId,socialNetwork: socialNetwork,socialNetworkTokenId: socialNetworkTokenId,registrationId: registrationId)
    }*/

    
}