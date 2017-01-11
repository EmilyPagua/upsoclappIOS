//
//  CustomerSingleton.swift
//  appupsocl
//
//  Created by upsocl on 06-01-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class UserSingleton {
    
    class var sharedInstance : UserSingleton {
        struct Static {
            static let instance: UserSingleton = UserSingleton()
        }
        return Static.instance
    }
    
    var ITEMS_KEY = "userLogin"
    
    func addUser(_ item: UserLogin ){
        
        self.saveUserLogin(item: item)
        var user = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
        user[item.email] = ["email": item.email ,
                            "firstName": item.firstName,
                            "lastName": item.lastName,
                            "userId": item.userId,
                            "location":  getLocationPhone(),
                            "birthday": item.birthday,
                            "imagenURL": item.imagenURL.absoluteString,
                            "token": item.token,
                            "socialNetwork" : item.socialNetwork,
                            "socialNetworkTokenId": item.socialNetworkTokenId,
                            "registrationId": item.registrationId]

        UserDefaults.standard.set(user, forKey: ITEMS_KEY)
    }
    
    
    func getUserLogin() -> [UserLogin] {
        let userLogin  = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(userLogin.values)
        
        return items.map({
            let item = $0 as! [String:AnyObject]
            
            return UserLogin(email: item["email"] as! String,
                             firstName: item["firstName"] as! String,
                             lastName: item["lastName"] as! String,
                             location: item["location"] as! String,
                             birthday: item["birthday"] as! String,
                             imagenURL: NSURL(string: item["imagenURL"] as! String) as! URL,
                             token: item["token"] as! String,
                             userId: item["userId"] as! String,
                             socialNetwork: item["socialNetwork"] as! String,
                             socialNetworkTokenId: item["socialNetworkTokenId"] as! String,
                             registrationId: item["registrationId"] as! String)
        }).sorted(by: {(left: UserLogin, right: UserLogin) -> Bool in
            (left.email.compare(right.email) == .orderedAscending)
        })
    }
    
    
    func removeUseLogin() -> Void {
        if var userLogin = UserDefaults.standard.dictionary(forKey: ITEMS_KEY){
            print ("Removido \(userLogin)")
            userLogin.removeAll()
            UserDefaults.standard.set(userLogin, forKey: ITEMS_KEY)
        }else{
            print("vacio")
        }
    }
    
    func saveUserLogin(item: UserLogin) {
        
        print (item.email)
        
        //var urlPath = "http://quiz.upsocl.com/dev/wp-json/wp/v2/customers?name="+customer.firstName+"&last_name="+customer.lastName+"&email="+customer.email+"&birthday="+customer.birthday+"&location="+customer.location+"&social_network_login="+customer.socialNetwork+"&registration_id="+customer.registrationId
        
        var urlPath = "http://quiz.upsocl.com/dev/wp-json/wp/v2/customers?name=pruebaIOS2&last_name=pruebaIOS2&email=pruebaIOS2@gmail.com&birthday=00-00-0000&location=Chile&social_network_login=facebook&registration_id=qwedsazxc2"
        
        urlPath =  urlPath.replacingOccurrences(of: " ", with: "%20%")
        
        print (urlPath)
        let request = NSMutableURLRequest(url: URL(string: urlPath)!)
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        item.userId.appending("0")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            guard error == nil else {
                MessageAlert.sharedInstance.createViewMessage("Problemas, verifique su conexión a datos", title: "Error!")
                return
            }
            
            guard data != nil else {
                print("ERROR_ NO PUEDE RECIBIR POST Customer")
                return
            }
            
            let nsdata = NSData(data: data!) as Data
            let json : AnyObject!
            do {
                json = try JSONSerialization.jsonObject(with: nsdata, options: []) as AnyObject!
                let id = json["success"] as! Bool
                if id == true {
                    let userId = json["id"] as! String
                    item.userId.appending(userId)
                }else{
                    print (json["message"] as! String)
                }
                
            }catch let error as NSError{
                print ("ERROR_ "+error.localizedDescription)
                json=nil
                return
            }
        })
        task.resume()
    }
    
    func getLocationPhone() -> String {
        
        var location =  ""
        let allLocaleIdentifiers : Array<String> = Locale.availableIdentifiers as Array<String>
        let currentLocale = Locale.current
        let countryCode = (currentLocale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
        let englishLocale : Locale = Locale.init(identifier : countryCode! )
        
        for anyLocaleID in allLocaleIdentifiers {
            
            let theEnglishName : String? = (englishLocale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: anyLocaleID)
            if anyLocaleID.range(of: countryCode!) != nil {
                location = theEnglishName!
            }
        }
        if location.isEmpty{
            return "No identificado"
        }else{
            return location
        }
    }
}
