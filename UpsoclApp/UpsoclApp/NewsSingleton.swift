//
//  TodoList.swift
//  appupsocl
//
//  Created by upsocl on 05-01-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//
import Foundation
import UIKit


class NewsSingleton {
    class var sharedInstance : NewsSingleton {
        struct Static {
            static let instance: NewsSingleton = NewsSingleton()
        }
        return Static.instance
    }
    
    var ITEMS_KEY = "todoLis"
    
    func addNotification(_ item: PostNotification) {
        
        //save cache
        var todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
        todoDictionary[String(item.idPost)] = ["idPost": item.idPost,
                                       "title": item.title,
                                       "subTitle": item.subTitle ,
                                       "UUID": item.UUID,
                                       "imageURL": item.imageURL,
                                       "date": item.date,
                                       "link": item.link,
                                       "category": item.category,
                                       "author": item.author,
                                       "content": item.content,
                                       "isRead": item.isRead]
        
        UserDefaults.standard.set(todoDictionary, forKey: ITEMS_KEY)
        
        let notification = UILocalNotification()
        notification.alertBody = "Todo Item \"\(item.title)\" Is Overdue"
        notification.alertAction = "open"
        notification.fireDate =  Date()
        notification.userInfo = ["title": item.title, "subTitle": item.subTitle]
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
    func allItems() -> [PostNotification]  {
        
        let todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        print (items.count)
        
        return items.map({
            let item = $0 as! [String:AnyObject]
            
            return PostNotification(idPost: item["idPost"] as! Int,
                                    title: item["title"] as! String,
                                    subTitle: item["subTitle"] as! String,
                                    UUID: item["UUID"] as! String!,
                                    imageURL: item["imageURL"] as! String,
                                    date: item["date"] as! String,
                                    link: item["link"] as! String,
                                    category: item["category"] as! String,
                                    author: item["author"] as! String,
                                    content: item["content"] as! String,
                                    isRead : item["isRead"] as! Bool)
                
            }).sorted(by: {(left: PostNotification, right: PostNotification) -> Bool in
                
                (left.idPost.description.compare(right.idPost.description) == .orderedAscending)
            })
     
    }
    
    func removeItem(_ item: PostNotification) -> Void {
        let sheduledNotification: [UILocalNotification]? =  UIApplication.shared.scheduledLocalNotifications
        
        guard sheduledNotification != nil else{return}
        
        //elmina la notificacion enviada
        for notification in sheduledNotification! {
            if (notification.userInfo!["UUID"] as! String == item.UUID){
                UIApplication.shared.cancelLocalNotification(notification)
                break
            }
        }
        
        if var todoItem = UserDefaults.standard.dictionary(forKey: ITEMS_KEY){
            todoItem.removeValue(forKey: String(item.idPost))
            UserDefaults.standard.set(todoItem, forKey: ITEMS_KEY)
        }
        
    }
    
    func removeAllItem() {
        if var todoItem = UserDefaults.standard.dictionary(forKey: ITEMS_KEY){
            print ("Remove  \(todoItem.count)")
            todoItem.removeAll()
            UserDefaults.standard.set(todoItem, forKey: ITEMS_KEY)
        }
    }
    
}
