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
    let url_privacity = "//http://upsocl.com/wp-json/wp/v2/pages/445196"

    //save Customer
    func saveCustomer(_ customer: Customer){
        customer.location = getLocationPhone()
        
     /*   print (customer.firstName)
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
        
        urlPath =  urlPath.replacingOccurrences(of: " ", with: "%20%")
        
        let request = NSMutableURLRequest(url: URL(string: urlPath)!)
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            guard error == nil else {
                print("error calling POST custumer : " + urlPath)
                print (error?.localizedDescription)
                return
            }
            
            guard data != nil else {
                print("Error: did not receive data POST Customer")
                return
            }
            
            let nsdata = NSData(data: data!) as Data
            let json : AnyObject!
            do {
                json = try JSONSerialization.jsonObject(with: nsdata, options: []) as AnyObject!
                let id = json["success"] as! Int
                if id == 0 {
                    customer.userId = "0"}
                else{
                    customer.userId = json["id"] as! String }
                
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
    func loadAllNews(_ wrapper: [News]?,  urlPath: String,  completionHandler: @escaping ([News]?, NSError?) -> Void) {

        if wrapper == nil{
            completionHandler(nil, nil)
            return
        }
        
        let urlPath = urlPath.replacingOccurrences(of: "ñ", with: "n")
            .replacingOccurrences(of: "í", with: "i")
            .replacingOccurrences(of: "ó", with: "o")
            .replacingOccurrences(of: "á", with: "a")
            .replacingOccurrences(of: " ", with: "%20")
        
        self.newsList = wrapper!
        guard let url = URL(string: urlPath) else{
            print("hay un error url")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                print("error calling GET on: " + urlPath)
                print (error?.localizedDescription)
                return
            }
            
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
            
            let nsdata = NSData(data: data!) as Data
            self.convertJson(nsdata)
            DispatchQueue.main.async(execute: {
                completionHandler(self.newsList, nil)
            })
            
        })
        task.resume()
    }
    
    //load 1
    func loadNews(_ wrapper: [News]?,  urlPath: String, completionHandler: @escaping ([News]?, NSError?) -> Void) {
        
        if wrapper == nil{
            completionHandler(nil, nil)
            return
        }
        
        self.newsList = wrapper!
        guard let url = URL(string: urlPath) else{
            print("hay un error")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
            
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
            
            let nsdata = NSData(data: data!) as Data            
            
            let json : AnyObject!
            do {
                json = try JSONSerialization.jsonObject(with: nsdata, options: []) as? NSDictionary
            }catch{
                json=nil
                return
            }
            self.encodeNews(json)
            DispatchQueue.main.async(execute: {
                
                completionHandler(self.newsList, nil)
            })
        })
        task.resume()
    }
    
    
    func createViewMessage(_ message: String){
        let alertView = UIAlertView(title: "Mensaje", message: message, delegate: self, cancelButtonTitle: "Aceptar")
        alertView.tag = 1
        alertView.show()
    }
    
    func convertJson(_ nsdata: Data) -> Void {
        let json : AnyObject!
        do {
            json = try JSONSerialization.jsonObject(with: nsdata, options: []) as AnyObject!
        }catch{
            json=nil
            return
        }
        
        if let list =  json as? NSArray{

            for i in 0 ..< list.count  {
                self.encodeNews(list[i] as AnyObject)
            }
        }
    }
    
    func encodeNews(_ object: AnyObject) {
        
        if let data_block = object as? [String: AnyObject]
        {
            var title = (data_block["title"]?.value(forKey: "rendered") as? String)!
            let id  = data_block["id"] as! Int
            
            var meal: News
            
            if id == 1039 {
                let content  = (data_block["content"]?.value(forKey: "rendered") as? String)!
            
                meal = News(id: id,
                                title: title,
                                content: content,
                                imageURL: "",
                                date: "",
                                link: "",
                                category: "" ,
                                author: "")!
                
                self.newsList.append(meal)
                return
            }
            if id == 445196{
                
                let content  = (data_block["content"]?.value(forKey: "rendered") as? String)!

                meal = News(id: id,
                            title: title,
                            content: content,
                            imageURL: "",
                            date: "",
                            link: "",
                            category: "" ,
                            author: "")!
                
                self.newsList.append(meal)
                return
            }
            
            let content  = (data_block["content"]?.value(forKey: "rendered") as? String)!
            let imageURL  = data_block["featured_media"] as? String!
            let date  = data_block["date"] as? String!
            let link  = data_block["link"] as? String!
            var category  = data_block["categories_name"] as? String!
            let authorLastName  = data_block["author_last_name"] as? String!
            let authorFirstName = data_block["author_first_name"] as? String!
            
            
            if category?.description.uppercased() == "AI"{
                category = "Portada"
            }
            
                title = title.replacingOccurrences(of: "&#8220;", with: "'")
                    .replacingOccurrences(of: "&#8221;", with: "'")
                    .replacingOccurrences(of: "&#8221;", with: "'")
                    .replacingOccurrences(of: "&#8216;", with: "'")
                    .replacingOccurrences(of: "&#8217;", with: "'")
                    .replacingOccurrences(of: "&#8230;", with: "'")
                
                meal = News(id: id,
                                title: title,
                                content: content,
                                imageURL: imageURL,
                                date: date,
                                link: link,
                                category: category ,
                                author: authorLastName!+" "+authorFirstName!)!

            
                self.newsList.append(meal)
                return
        }
    }

    func loadImage(urlImage: String, completionHandler: @escaping (UIImage, NSError?) -> Void ){
    
        if (urlImage.isEmpty) {
            completionHandler(UIImage(named: "webkit-featured")!, nil)
            
        }else{
             print(urlImage as String)
            
            let imgURL = URL(string: urlImage as String)
            if imgURL != nil {
                let task = URLSession.shared.dataTask(with: imgURL!, completionHandler: { (responseData, responseUrl, error) -> Void in
                    
                    print (responseData)
                    print (imgURL)
                    
                    // if responseData is not null...
                    if let data = responseData{
                        print (data)
                        completionHandler(UIImage(data: data)!, nil)
                    }else{
                        print ("data = null")
                    }
                }) 
                // Run task
                task.resume()
            }else {
                completionHandler(UIImage(named: "webkit-featured")!, nil)
            }
        }
    }
    
    
    func saveUser(_ customer: Customer){
        
        print ("Customer ID " + customer.userId)
        let preferences = UserDefaults.standard
        preferences.setValue(customer.email , forKey: Customer.PropertyKey.email)
        preferences.setValue(customer.firstName, forKey: Customer.PropertyKey.firstName )
        preferences.setValue(customer.lastName, forKey: Customer.PropertyKey.lastName)
        preferences.setValue(customer.userId, forKey: Customer.PropertyKey.userId)
        preferences.setValue(customer.socialNetwork, forKey: Customer.PropertyKey.socialNetwork)
        preferences.setValue(customer.socialNetworkTokenId, forKey: Customer.PropertyKey.socialNetworkTokenId)
        preferences.setValue(customer.birthday, forKey: Customer.PropertyKey.birthday )
        preferences.setValue(customer.token, forKey: Customer.PropertyKey.token)
        preferences.setValue(customer.location, forKey: Customer.PropertyKey.location)
        
        let url = String (describing: customer.imagenURL)
        preferences.setValue(url , forKey: Customer.PropertyKey.imagenURL)
        
        preferences.synchronize()
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
