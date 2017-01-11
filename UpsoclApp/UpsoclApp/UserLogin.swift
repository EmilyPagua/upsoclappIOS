//
//  UserLogin.swift
//  appupsocl
//
//  Created by upsocl on 11-01-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

struct UserLogin {
    
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
    
    init (email: String,firstName: String, lastName: String,  location: String, birthday: String, imagenURL: URL,  token: String, userId: String, socialNetwork: String, socialNetworkTokenId: String, registrationId: String){
        
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
    }
}

