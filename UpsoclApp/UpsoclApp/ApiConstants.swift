//
//  WordpressKey.swift
//  UpsoclApp
//
//  Created by upsocl on 07-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class ApiConstants  {
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("apiConstants")
    
    struct PropertyKey {
        
        static let baseURL = "http://upsocl.com/wp-json/wp/v2"
        static let listPost = "/posts"
        static let pageFilter = "?filter[paged]="
        static let filterWord = "?filter[s]="
        static let filterCategoryName = "?filter[category_name]="
        static let filterPageForYou = "&filter[paged]="
        static let filterPostId = "/posts/{id}"
    }
}

