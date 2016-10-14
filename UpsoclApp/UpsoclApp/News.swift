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

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("news")
    
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

    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(idNews, forKey: PropertyKey.idKey)
        aCoder.encode(titleNews, forKey: PropertyKey.titleKey)
        aCoder.encode(contentNews, forKey: PropertyKey.contentKey)
        aCoder.encode(imageURLNews, forKey: PropertyKey.imageURLKey)
        aCoder.encode(dateNews, forKey: PropertyKey.dateKey)
        aCoder.encode(linkNews, forKey: PropertyKey.linkKey)
        aCoder.encode(categoryNews, forKey: PropertyKey.categoryKey)
        aCoder.encode(authorNews, forKey: PropertyKey.authorKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id    = aDecoder.decodeObject(forKey: PropertyKey.idKey) as! Int
        let title = aDecoder.decodeObject(forKey: PropertyKey.titleKey) as! String
        let content = aDecoder.decodeObject(forKey: PropertyKey.contentKey) as? String
        let imageURL = aDecoder.decodeObject(forKey: PropertyKey.imageURLKey) as? String
        let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as! String
        let link = aDecoder.decodeObject(forKey: PropertyKey.linkKey) as! String
        let category = aDecoder.decodeObject(forKey: PropertyKey.categoryKey) as! String
        let author = aDecoder.decodeObject(forKey: PropertyKey.authorKey) as! String
        
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
