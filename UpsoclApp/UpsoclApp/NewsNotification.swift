//
//  TodoItem.swift
//  appupsocl
//
//  Created by upsocl on 05-01-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

struct NewsNotification {
    var idPost: String
    var title: String
    var subTitle: String
    var UUID: String
    
    init (idPost: String, title: String, subTitle: String, UUID: String){
        self.idPost = idPost
        self.title = title
        self.subTitle = subTitle
        self.UUID = UUID
    }
}
