//
//  ServicesConnection.swift
//  appupsocl
//
//  Created by upsocl on 07-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class ServicesConnection  {
    
    var newsList = [News]()
    
    let urlPath = "http://upsocl.com/wp-json/wp/v2/posts"
    let url_privacity = "//http://upsocl.com/wp-json/wp/v2/pages/445196"
    //Load 10 News
    func loadAllNews(_ wrapper: [News]?,  urlPath: String,  completionHandler: @escaping ([News]?, NSError?) -> Void) {

      //  NSLog ("urlPath \(urlPath) ")
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
            NSLog("ERROR_ ServicesConnection loadAllNews en URL")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                NSLog("ERROR_ ServicesConnection loadAllNews calling GET on: \( urlPath ) Error:  \(error?.localizedDescription ?? "Error en url" ) " )
                MessageAlert.sharedInstance.createViewMessage("Problemas, verifique su conexión a datos", title: "Error!")
                return
            }
            
            guard data != nil else {
                NSLog("ERROR_ ServicesConnection loadAllNews did not receive data")
                MessageAlert.sharedInstance.createViewMessage("Problemas, verifique su conexión a datos",title: "Error!")
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
            NSLog("ERROR_ ServicesConnection loadNews en URL")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                NSLog("ERROR_ ServicesConnection loadNews calling GET on: \(urlPath) Error: \(error?.localizedDescription ?? "Error en url" )" )
                MessageAlert.sharedInstance.createViewMessage("Problemas, verifique su conexión a datos",title: "Error!")
                return
            }
            
            guard data != nil else {
                NSLog("ERROR_ ServicesConnection loadNews did not receive data")
                MessageAlert.sharedInstance.createViewMessage("Problemas, verifique su conexión a datos",title: "Error!")
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
                    .replacingOccurrences(of: "&#8242;", with: "'")
            
            
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
            let imgURL = URL(string: urlImage as String)
            if imgURL != nil {
                let task = URLSession.shared.dataTask(with: imgURL!, completionHandler: { (responseData, responseUrl, error) -> Void in
                    
                    if let data = responseData{
                        completionHandler(UIImage(data: data)!, nil)
                    }else{
                        NSLog ("data = null")
                    }
                }) 
                // Run task
                task.resume()
            }else {
                completionHandler(UIImage(named: "webkit-featured")!, nil)
            }
        }
    }

}
