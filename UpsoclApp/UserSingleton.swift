//
//  UserSingleton.swift
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
    var TOKEN_KEY = "token"
    
    func saveTokent(token: String){
        UserDefaults.standard.set(token, forKey: TOKEN_KEY)
    }
    
    func getTokent() -> String {
        
        let userLogin  = UserDefaults.standard.dictionary(forKey: TOKEN_KEY) ?? [:]
        let items = Array(userLogin.values)
        
        print (items)
        
        return ""
    }
    
    func addUser(_ item: UserLogin ){
        
        if (item.isLogin){
            self.saveUserLogin(item: item)
        }
        
        var user = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
        let tokenGCM = UserDefaults.standard.object(forKey: TOKEN_KEY) ?? "--"
    
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
                            "registrationId": tokenGCM ,
                            "isLogin" : item.isLogin]

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
                             registrationId: item["registrationId"] as! String,
                             isLogin: item["isLogin"] as! Bool)
            
        }).sorted(by: {(left: UserLogin, right: UserLogin) -> Bool in
            (left.email.compare(right.email) == .orderedAscending)
        })
    }
    
    
    func removeUseLogin() -> Void {
        if var userLogin = UserDefaults.standard.dictionary(forKey: ITEMS_KEY){
            userLogin.removeAll()
            UserDefaults.standard.set(userLogin, forKey: ITEMS_KEY)
        }
    }
    
    func saveUserLogin(item: UserLogin) {
        
        NSLog ("item.email  \(item.email)")
        
        var urlPath = "http://quiz.upsocl.com/dev/wp-json/wp/v2/customers?name="+item.firstName+"&last_name="+item.lastName+"&email="+item.email+"&birthday="+item.birthday+"&location="+item.location+"&social_network_login="+item.socialNetwork+"&registration_id="+item.registrationId
        
        //var urlPath = "http://quiz.upsocl.com/dev/wp-json/wp/v2/customers?name=pruebaIOS2&last_name=pruebaIOS2&email=pruebaIOS2@gmail.com&birthday=00-00-0000&location=Chile&social_network_login=facebook&registration_id=qwedsazxc2"
        
       urlPath =  urlPath.replacingOccurrences(of: "ñ", with: "n")
        .replacingOccurrences(of: " ", with: "_")
 
        
        print ("urlPath  \(urlPath)")
        let request = NSMutableURLRequest(url: URL(string: urlPath)!)
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        item.userId.appending( "0" as String)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            guard error == nil else {
                MessageAlert.sharedInstance.createViewMessage("Problemas, verifique su conexión a datos", title: "Error!")
                return
            }
            guard data != nil else {
                NSLog("ERROR_ NO PUEDE RECIBIR POST USER desde BD")
                return
            }
            
            let nsdata = NSData(data: data!) as Data
            let json : AnyObject!
            do {
                json = try JSONSerialization.jsonObject(with: nsdata, options: []) as AnyObject!
                let id = json["success"] as! Bool
                if id {
                    let userId = json["id"] as! Int
                    item.userId.appending(userId.description)
                }else{
                    NSLog (json["message"] as! String)
                }
                
            }catch let error as NSError{
                NSLog ("ERROR_ "+error.localizedDescription)
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
