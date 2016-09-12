//
//  ServicesConnection.swift
//  UpsoclApp
//
//  Created by upsocl on 07-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class ServicesConnection {
    
    var newsList = [News]()
    
    let urlPath = "http://upsocl.com/wp-json/wp/v2/posts"
    let filterPaged =  "?filter[paged]="
    

    func loadNews(wrapper: [News]?,  urlPath: String, completionHandler: ([News]?, NSError?) -> Void) {

        if wrapper == nil
        {
            completionHandler(nil, nil)
            return
        }
        
        self.newsList = wrapper!
        
        //let urlPathWordpress = urlPath + filterPaged + paged
        print (urlPath)
        guard let url = NSURL(string: urlPath) else{
            print("hay un error")
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
    
    func convertJson(nsdata: NSData) -> Void {
        let json : AnyObject!
        do {
            json = try NSJSONSerialization.JSONObjectWithData(nsdata, options: [])
        }catch{
            json=nil
            return
        }
        
        if let list =  json as? NSArray{

            for (var i = 0; i < list.count ; i += 1 ){
                if let data_block = list[i] as? NSDictionary
                {
                    let title = (data_block["title"]?.valueForKey("rendered") as? String)!
                    let id  = data_block["id"] as! Int
                    let content  = (data_block["content"]?.valueForKey("rendered") as? String)!
                    let imageURL  = data_block["featured_media"] as? String!
                    let date  = data_block["date"] as? String!
                    let link  = data_block["link"] as? String!
                    let category  = data_block["categories_name"] as? String!
                    let authorLastName  = data_block["author_last_name"] as? String!
                    let authorFirstName = data_block["author_first_name"] as? String!
                    
                    let meal = News(id: id,
                                    title: title,
                                    content: content,
                                    imageURL: imageURL,
                                    date: date,
                                    link: link,
                                    category: category ,
                                    author: authorLastName!+" "+authorFirstName!)!
                    // Add a new meal.
                    self.newsList.append(meal)
                }
            }
        }
        print("End ConvertJson-------" + String(newsList.count))
    }

    func loadImage(urlImage: String?, completionHandler: (UIImage, NSError?) -> Void ){
        
        if (urlImage == nil || (urlImage!.isEmpty) ) {
            completionHandler(UIImage(named: "webkit-featured")!, nil)
            
        }else{
            
            let imgURL = NSURL(string: urlImage!)
            
            if (imgURL != nil){
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
    
    /*********
 let json : AnyObject!
 do {
 json = try NSJSONSerialization.JSONObjectWithData(nsdata, options: [])
 }catch{
 json=nil
 return
 }
 
 if let list =  json as? NSArray{
 
 for (var i = 0; i < list.count ; i++ ){
 if let data_block = list[i] as? NSDictionary
 {
 let title = (data_block["title"]?.valueForKey("rendered") as? String)!
 let id  = data_block["id"] as! Int
 let content  = (data_block["content"]?.valueForKey("rendered") as? String)!
 let imageURL  = data_block["featured_media"] as? String!
 let date  = data_block["date"] as? String!
 let link  = data_block["link"] as? String!
 let category  = data_block["categories_name"] as? String!
 let authorLastName  = data_block["author_last_name"] as? String!
 let authorFirstName = data_block["author_first_name"] as? String!
 
 let meal = News(id: id,
 title: title,
 content: content,
 imageURL: imageURL,
 date: date,
 link: link,
 category: category ,
 author: authorLastName!+" "+authorFirstName!)!
 // Add a new meal.
 newsList.append(meal)
 }
 }
 }
 print("End ConvertJson-------" + String(newsList.count))
 
*/
}
