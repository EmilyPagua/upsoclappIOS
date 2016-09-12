//
//  News.swift
//  UpsoclApp
//
//  Created by upsocl on 02-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class News: NSObject, NSCoding  {
    
    var idNews: Int
    var titleNews: String
    var contentNews: String?
    var imageURLNews: String?
    var authorNews: String?
    var dateNews: String?
    var linkNews: String
    var categoryNews: String

    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("news")
    
    struct PropertyKey {
        
        static let idKey = "id"
        static let titleKey = "title"
        static let contentKey = "content"
        static let imageURLKey = "imageURL"
        static let authorKey = "author"
        static let dateKey = "date"
        static let linkKey = "link"
        static let categoryKey =  "category"
    }
    
    init? (id: Int, title: String, content: String!,
           imageURL: String?, date: String?,  link: String!, category: String!, author: String!){
        
        self.idNews = id
        self.titleNews = title
        self.contentNews = content
        self.imageURLNews = imageURL
        self.dateNews = date
        self.linkNews = link
        self.categoryNews = category
        self.authorNews =  author
        
        super.init()
    }

    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(idNews, forKey: PropertyKey.idKey)
        aCoder.encodeObject(titleNews, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(contentNews, forKey: PropertyKey.contentKey)
        aCoder.encodeObject(imageURLNews, forKey: PropertyKey.imageURLKey)
        aCoder.encodeObject(dateNews, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(linkNews, forKey: PropertyKey.linkKey)
        aCoder.encodeObject(categoryNews, forKey: PropertyKey.categoryKey)
        aCoder.encodeObject(authorNews, forKey: PropertyKey.authorKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id    = aDecoder.decodeObjectForKey(PropertyKey.idKey) as! Int
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let content = aDecoder.decodeObjectForKey(PropertyKey.contentKey) as? String
        let imageURL = aDecoder.decodeObjectForKey(PropertyKey.imageURLKey) as? String
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! String
        let link = aDecoder.decodeObjectForKey(PropertyKey.linkKey) as! String
        let category = aDecoder.decodeObjectForKey(PropertyKey.categoryKey) as! String
        let author = aDecoder.decodeObjectForKey(PropertyKey.authorKey) as! String
        
        // Must call designated initializer.
        self.init(id: id,
                  title: title,
                  content: content,
                  imageURL: imageURL,
                  date: date,
                  link: link,
                  category: category,
                  author: author)
    }
}
