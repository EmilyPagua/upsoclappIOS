//
//  ButtonSingleton.swift
//  appupsocl
//
//  Created by upsocl on 06-01-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

class ButtonSingleton {
    
    func processingNotification(notification: [PostNotification], segue: UIStoryboardSegue) -> Void {
        
        let news = News(id: (notification.first?.idPost)!,
                              title: (notification.first?.title)!,
                              content: notification.first?.content,
                              imageURL: notification.first?.imageURL,
                              date: notification.first?.date,
                              link: notification.first?.link,
                              category: notification.first?.category,
                              author: notification.first?.author)!
        
        let detailViewController = segue.destination as! PageViewController
        var newsList = [News]()
        newsList.append(news)
        detailViewController.newsList = newsList
        
        var post = notification.first
        post?.isRead  = true
        notificationButton.image = UIImage(named: "notification_disable")
        
        NewsSingleton.sharedInstance.removeAllItem()
        NewsSingleton.sharedInstance.addNotification(post!)
    }
}
