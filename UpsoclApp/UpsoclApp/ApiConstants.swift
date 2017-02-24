//
//  WordpressKey.swift
//  appupsocl
//
//  Created by upsocl on 07-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class ApiConstants  {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("apiConstants")
    
    struct PropertyKey {
        
        static let baseURL = "http://upsocl.com/wp-json/wp/v2"
        static let listPost = "/posts"
        static let pageFilter = "?page="
        static let filterWord = "&search="
        static let filterCategoryName = "?categories="
        static let filterPageForYou = "&page="
        static let filterPostId = "/posts/{id}"
    
        static let googleAnalyticsTrackingId = "UA-44944096-19"
    }
}

