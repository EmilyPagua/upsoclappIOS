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
    
    func addNotification(_ item: NewsNotification) {
        
        //save cache
        var todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
        todoDictionary[item.idPost] = ["idPost": item.idPost, "title": item.title, "subTitle": item.subTitle , "UUID": item.UUID]
        
        UserDefaults.standard.set(todoDictionary, forKey: ITEMS_KEY)
        
        let notification = UILocalNotification()
        notification.alertBody = "Todo Item \"\(item.title)\" Is Overdue"
        notification.alertAction = "open"
        notification.fireDate =  Date()
        notification.userInfo = ["title": item.title, "subTitle": item.subTitle]
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
    func allItems() -> [NewsNotification]  {
        
        let todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        print (items.count)
        
        return items.map({
            let item = $0 as! [String:AnyObject]
            
            return NewsNotification(idPost: item["idPost"] as! String,
                                    title: item["title"] as! String,
                                    subTitle: item["subTitle"] as! String,
                                    UUID: item["UUID"] as! String!)
                
            }).sorted(by: {(left: NewsNotification, right:NewsNotification) -> Bool in
                (left.idPost.compare(right.idPost) == .orderedAscending)
            })
     
    }
    
    func removeItem(_ item: NewsNotification) -> Void {
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
            //todoItem.removeAll()
            todoItem.removeValue(forKey: item.idPost)
            UserDefaults.standard.set(todoItem, forKey: ITEMS_KEY)
        }
        
    }
    
    func removeAllItem() {
        if var todoItem = UserDefaults.standard.dictionary(forKey: ITEMS_KEY){
            todoItem.removeAll()
            print ("Remove\(todoItem.count)")
            UserDefaults.standard.set(todoItem, forKey: ITEMS_KEY)
        }
    }
    
}
