//
//  PageItemController.swift
//  UpsoclApp
//
//  Created by upsocl on 09-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
    
    @IBOutlet weak var webViewContent: UIWebView!
        
    @IBAction func comeBack(sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.hidden =  false
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    let fonts = "<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'><link href='http://fonts.googleapis.com/css?family=Raleway:400,600' rel='stylesheet' type='text/css'>"
    let meta = "<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'>"
    let style = "<link rel='stylesheet' type='text/css' media='all' href='http://www.upsocl.com/wp-content/themes/upso3/style.css'>"
    
    let baseURL = NSURL(string: "http://api.instagram.com/oembed")
    var itemIndex: Int = 0
    var news =  News?()
    
    @IBOutlet weak var contentWebView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContent()
    }
    
    @IBOutlet weak var bookmark: UIBarButtonItem!
    @IBAction func bookmarkButton(sender: UIBarButtonItem) {

        let preferences = NSUserDefaults.standardUserDefaults()
        let currentLevelKey = String(news!.idNews)
        let currentLevel = preferences.objectForKey(currentLevelKey)
        
        if currentLevel == nil {
            
            let objectJson: NSMutableDictionary =  NSMutableDictionary()
            objectJson.setValue(news!.idNews, forKey: News.PropertyKey.idKey)
            objectJson.setValue(news!.titleNews, forKey: News.PropertyKey.titleKey)
            objectJson.setValue(news!.imageURLNews, forKey: News.PropertyKey.imageURLKey)
            objectJson.setValue(news!.authorNews, forKey: News.PropertyKey.authorKey)
            objectJson.setValue(news!.categoryNews, forKey: News.PropertyKey.categoryKey)
            objectJson.setValue(news!.linkNews, forKey: News.PropertyKey.linkKey)
            objectJson.setValue(news!.contentNews, forKey: News.PropertyKey.contentKey)
            
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(objectJson, options: NSJSONWritingOptions())
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            
            preferences.setValue(jsonString, forKey: currentLevelKey )            
            bookmark.image = UIImage(named: "bookmarkActive")
        } else {
            preferences.removeObjectForKey(currentLevelKey)
            bookmark.image = UIImage(named: "bookmarkInactive")
        }
        preferences.synchronize()
    }
    
    func loadContent() {
        
        var contentDetail = meta + style + fonts 
        
        if news != nil {
            
            loadIsBookmark()
            
            if news!.imageURLNews != nil{
                let imagen  = "<img src="+news!.imageURLNews!+" alt=\"Photo of Ton Sai Bay on Koh Phi-Phi Island in Thailand\">"
                contentDetail = contentDetail + imagen
            }
            
            let title = "<h1>"+news!.titleNews+"</h1>"
            let detailAuthor = "<h5> Autor: <font color=\"#009688\">"+news!.authorNews!+" </font> . El: <font color=\"#009688\"> "+news!.dateNews!+" </font> <h5>"
            let category = "<h5> Categorias: <font color=\"#009688\">"+news!.categoryNews+"</font> <h5>"
            let line = "<hr  color=\"#009688\" />"
            let publicity = ""
            
            if news != nil {
                let contentDetail = contentDetail + title + detailAuthor + category + line + publicity + news!.contentNews!
                let baseURL = NSURL(string: "http://api.instagram.com/oembed")
                webViewContent.loadHTMLString(contentDetail, baseURL: baseURL)
            }
        }
    }
    
    func loadIsBookmark() {
        
        let preferences = NSUserDefaults.standardUserDefaults()
        let currentLevel = preferences.objectForKey(String(news!.idNews))
        
        if currentLevel != nil{
            bookmark.image = UIImage(named: "bookmarkActive")
        }else{
            bookmark.image = UIImage(named: "bookmarkInactive")
        }
    }
}
