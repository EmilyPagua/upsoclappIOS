//
//  TodoItem.swift
//  appupsocl
//
//  Created by upsocl on 05-01-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

struct PostNotification {
    
    var idPost: Int
    var title: String
    var subTitle: String
    var UUID: String
    var imageURL: String
    var author: String
    var date: String
    var link: String
    var category: String
    var content: String
    var isRead: Bool
    
    
    init (idPost: Int, title: String, subTitle: String, UUID: String, imageURL: String, date: String,  link: String, category: String, author: String, content: String, isRead: Bool){
        
        self.idPost = idPost
        self.title = title
        self.subTitle = subTitle
        self.UUID = UUID
        self.imageURL = imageURL
        self.author = author
        self.date = date
        self.link =  link
        self.category = category
        self.content =  content
        self.isRead = isRead
    }
}
