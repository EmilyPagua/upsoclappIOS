//
//  ServicesConnection.swift
//  UpsoclApp
//
//  Created by upsocl on 07-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class ServicesConnection  {
    
    var newsList = [News]()
    
    let urlPath = "http://upsocl.com/wp-json/wp/v2/posts"
    let filterPaged =  "?filter[paged]="

    //save Customer
    func saveCustomer(customer: Customer){
        customer.location = getLocationPhone()
        
        /*print (customer.firstName)
        print (customer.lastName)
        print (customer.email)
        print (customer.birthday)
        print (customer.location)
        print (customer.socialNetwork)
        print (customer.socialNetworkTokenId)
        print (customer.registrationId)
        print (customer.imagenURL)*/
        
        //var urlPath = "http://quiz.upsocl.com/dev/wp-json/wp/v2/customers?name="+customer.firstName+"&last_name="+customer.lastName+"&email="+customer.email+"&birthday="+customer.birthday+"&location="+customer.location+"&social_network_login="+customer.socialNetwork+"&registration_id="+customer.registrationId
        
        var urlPath = "http://quiz.upsocl.com/dev/wp-json/wp/v2/customers?name=pruebaIOS2&last_name=pruebaIOS2&email=pruebaIOS2@gmail.com&birthday=00-00-0000&location=Chile&social_network_login=facebook&registration_id=qwedsazxc2"
        
        urlPath =  urlPath.stringByReplacingOccurrencesOfString(" ", withString: "%20%")
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlPath)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            guard error == nil else {
                print("error calling POST custumer : " + urlPath)
                print (error?.localizedDescription)
                return
            }
            
            guard data != nil else {
                print("Error: did not receive data POST Customer")
                return
            }
            
            let nsdata = NSData(data: data!)
            let json : AnyObject!
            do {
                json = try NSJSONSerialization.JSONObjectWithData(nsdata, options: []) as? [String:AnyObject]
                let id = json["success"] as! Int
                if id == 0 {
                    customer.userId = "0"}
                else{
                    customer.userId = String(json["id"]) }
                
            }catch let error as NSError{
                print (error.localizedDescription)
                json=nil
                return
            }
            self.saveUser(customer)
        })
        task.resume()
    }
    
    //Load 10 News
    func loadAllNews(wrapper: [News]?,  urlPath: String,  completionHandler: ([News]?, NSError?) -> Void) {

        if wrapper == nil{
            completionHandler(nil, nil)
            return
        }
        
        let urlPath = urlPath.stringByReplacingOccurrencesOfString("ñ", withString: "n")
            .stringByReplacingOccurrencesOfString("í", withString: "i")
            .stringByReplacingOccurrencesOfString("ó", withString: "o")
            .stringByReplacingOccurrencesOfString("á", withString: "a")
            .stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        self.newsList = wrapper!
        guard let url = NSURL(string: urlPath) else{
            print("hay un error url")
            return
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                print("error calling GET on: " + urlPath)
                print (error?.localizedDescription)
                return
            }
            
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
            
            let nsdata = NSData(data: data!)
            self.convertJson(nsdata)
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self.newsList, nil)
            })
            
        })
        task.resume()
    }
    
    func loadNews(wrapper: [News]?,  urlPath: String, completionHandler: ([News]?, NSError?) -> Void) {
        
        if wrapper == nil{
            completionHandler(nil, nil)
            return
        }
        
        self.newsList = wrapper!
        guard let url = NSURL(string: urlPath) else{
            print("hay un error")
            return
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                print("error calling GET on: " + urlPath)
                print (error?.localizedDescription)
                //self.createViewMessage ("Problemas al obtener datos, verifique su conexion a internet..!")

                return
            }
            
            guard data != nil else {
                print("Error: did not receive data")
                //self.createViewMessage ("Problemas al obtener datos, verifique su conexion a internet..!")
                return
            }
            
            let nsdata = NSData(data: data!)            
            
            let json : AnyObject!
            do {
                json = try NSJSONSerialization.JSONObjectWithData(nsdata, options: []) as? NSDictionary
            }catch{
                json=nil
                return
            }
            self.encodeNews(json)
            dispatch_async(dispatch_get_main_queue(), {
                
                completionHandler(self.newsList, nil)
            })
        })
        task.resume()
    }
    
    
    func createViewMessage(message: String){
        let alertView = UIAlertView(title: "Mensaje", message: message, delegate: self, cancelButtonTitle: "Aceptar")
        alertView.tag = 1
        alertView.show()
    }
    
    func convertJson(nsdata: NSData) -> Void {
        let json : AnyObject!
        do {
            json = try NSJSONSerialization.JSONObjectWithData(nsdata, options: [])
        }catch{
            json=nil
            return
        }
        
        if let list =  json as? NSArray{

            for i in 0 ..< list.count  {
                self.encodeNews(list[i])
            }
        }
    }
    
    func encodeNews(object: AnyObject) {
        
        if let data_block = object as? [String: AnyObject]
        {
            var title = (data_block["title"]?.valueForKey("rendered") as? String)!
            let id  = data_block["id"] as! Int
            let content  = (data_block["content"]?.valueForKey("rendered") as? String)!
            let imageURL  = data_block["featured_media"] as? String!
            let date  = data_block["date"] as? String!
            let link  = data_block["link"] as? String!
            let category  = data_block["categories_name"] as? String!
            let authorLastName  = data_block["author_last_name"] as? String!
            let authorFirstName = data_block["author_first_name"] as? String!
            
            title = title.stringByReplacingOccurrencesOfString("&#8220;", withString: "'")
                        .stringByReplacingOccurrencesOfString("&#8221;", withString: "'")
                        .stringByReplacingOccurrencesOfString("&#8221;", withString: "'")
                        .stringByReplacingOccurrencesOfString("&#8216;", withString: "'")
                        .stringByReplacingOccurrencesOfString("&#8217;", withString: "'")
                        .stringByReplacingOccurrencesOfString("&#8230;", withString: "'")
            
            let meal = News(id: id,
                            title: title,
                            content: content,
                            imageURL: imageURL,
                            date: date,
                            link: link,
                            category: category ,
                            author: authorLastName!+" "+authorFirstName!)!
            
            self.newsList.append(meal)
        }
    }

    func loadImage(urlImage: String?, completionHandler: (UIImage, NSError?) -> Void ){
        
        if (urlImage == nil || (urlImage!.isEmpty) ) {
            completionHandler(UIImage(named: "webkit-featured")!, nil)
            
        }else{
            
            let imgURL = NSURL(string: urlImage!)
            if imgURL != nil {
                let task = NSURLSession.sharedSession().dataTaskWithURL(imgURL!) { (responseData, responseUrl, error) -> Void in
                    
                    // if responseData is not null...
                    if let data = responseData{
                        completionHandler(UIImage(data: data)!, nil)
                    }
                }
                // Run task
                task.resume()
            }else {
                completionHandler(UIImage(named: "webkit-featured")!, nil)
            }
        }
    }
    
    
    func saveUser(customer: Customer){
        
        print ("Customer ID " + customer.userId)
        let preferences = NSUserDefaults.standardUserDefaults()
        preferences.setValue(customer.email , forKey: Customer.PropertyKey.email)
        preferences.setValue(customer.firstName, forKey: Customer.PropertyKey.firstName )
        preferences.setValue(customer.lastName, forKey: Customer.PropertyKey.lastName)
        preferences.setValue(customer.imagenURL, forKey: Customer.PropertyKey.imagenURL)
        preferences.setValue(customer.userId, forKey: Customer.PropertyKey.userId)
        preferences.setValue(customer.socialNetwork, forKey: Customer.PropertyKey.socialNetwork)
        preferences.setValue(customer.socialNetworkTokenId, forKey: Customer.PropertyKey.socialNetworkTokenId)
        preferences.setValue(customer.birthday, forKey: Customer.PropertyKey.birthday )
        preferences.setValue(customer.token, forKey: Customer.PropertyKey.token)
        preferences.setValue(customer.location, forKey: Customer.PropertyKey.location)
        
        preferences.synchronize()
    }
    
    func getLocationPhone() -> String {
        
        var location =  ""
        let allLocaleIdentifiers : Array<String> = NSLocale.availableLocaleIdentifiers() as Array<String>
        let currentLocale = NSLocale.currentLocale()
        let countryCode = currentLocale.objectForKey(NSLocaleCountryCode) as? String
        let englishLocale : NSLocale = NSLocale.init(localeIdentifier : countryCode! )
        
        for anyLocaleID in allLocaleIdentifiers {
            
            let theEnglishName : String? = englishLocale.displayNameForKey(NSLocaleIdentifier, value: anyLocaleID)
            if anyLocaleID.rangeOfString(countryCode!) != nil {
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
