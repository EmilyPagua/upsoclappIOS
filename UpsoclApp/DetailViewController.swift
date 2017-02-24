//
//  DetailNewsController.swift
//  appupsocl
//
//  Created by upsocl on 05-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//
import UIKit

class DetailViewController:  UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var contentWeb: UIWebView!
    
    //var news: News?
    var news : News?
    var newsFirst : News?
    var newsTwo : News?
    var newsThree : News?
    var newsFour : News?
    var newsFive : News?
    
    var newsList = [News]()
    
    
    let fonts = "<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'><link href='http://fonts.googleapis.com/css?family=Raleway:400,600' rel='stylesheet' type='text/css'>"
    let meta = "<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'>"
    let style = "<link rel='stylesheet' type='text/css' media='all' href='http://www.upsocl.com/wp-content/themes/upso3/style.css'>"
    
    @IBOutlet weak var bookmarkButtonPres: UIBarButtonItem!
    
    @IBAction func bookmarkButton(_ sender: AnyObject) {
    
        let preferences = UserDefaults.standard
        let currentLevelKey = String(newsFirst!.idNews)
        let currentLevel = preferences.object(forKey: currentLevelKey)
        
        if currentLevel == nil {
            
            let objectJson: NSMutableDictionary =  NSMutableDictionary()
            objectJson.setValue(newsFirst?.idNews, forKey: News.PropertyKey.idKey)
            objectJson.setValue(newsFirst?.titleNews, forKey: News.PropertyKey.titleKey)
            objectJson.setValue(newsFirst?.imageURLNews, forKey: News.PropertyKey.imageURLKey)
            objectJson.setValue(newsFirst?.authorNews, forKey: News.PropertyKey.authorKey)
            objectJson.setValue(newsFirst?.categoryNews, forKey: News.PropertyKey.categoryKey)
            objectJson.setValue(newsFirst?.linkNews, forKey: News.PropertyKey.linkKey)
            objectJson.setValue(newsFirst?.contentNews, forKey: News.PropertyKey.contentKey)
            
            let jsonData = try! JSONSerialization.data(withJSONObject: objectJson, options: JSONSerialization.WritingOptions())
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
            
            preferences.setValue(jsonString, forKey: currentLevelKey )
            preferences.synchronize()
            
            bookmarkButtonPres.title = "esBoo"
        } else {
            preferences.removeObject(forKey: currentLevelKey)
            bookmarkButtonPres.title = "Book"
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentDetail = meta + style + fonts
        
        if newsFirst != nil {
            
            let preferences = UserDefaults.standard
            let currentLevel = preferences.object( forKey: String(newsFirst!.idNews))
            if currentLevel != nil{
                bookmarkButtonPres.title = "esBoo"
            }
            
            if newsFirst!.imageURLNews != nil{
                let imagen  = "<img src="+newsFirst!.imageURLNews!+" alt=\"Photo of Ton Sai Bay on Koh Phi-Phi Island in Thailand\">"
                contentDetail = contentDetail + imagen
            }
            
            let title = "<h1>"+newsFirst!.titleNews+"</h1>"
            let detailAuthor = "<h5> Autor: <font color=\"#009688\">"+newsFirst!.authorNews!+" </font> . El: <font color=\"#009688\"> "+newsFirst!.dateNews!+" </font> <h5>"
            let category = "<h5> Categorias: <font color=\"#009688\">"+newsFirst!.categoryNews+"</font> <h5>"
            let line = "<hr  color=\"#009688\" />"
            let publicity = ""
            
            if let news = newsFirst {
                let contentDetail = contentDetail + title + detailAuthor + category + line + publicity + news.contentNews!
                let baseURL = URL(string: "http://api.instagram.com/oembed")
                contentWeb.loadHTMLString(contentDetail, baseURL: baseURL)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadImage (_ urlImage: String?, view: UIImageView){
        
        if urlImage == nil {
            view.image = UIImage(named: "webkit-featured")
            return
        }
        
        guard let imgURL = URL(string: urlImage!) else{
            view.image = UIImage(named: "webkit-featured")
            return
        }
        
        let task = URLSession.shared.dataTask(with: imgURL, completionHandler: { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }) 
        // Run task
        task.resume()
    }
    
}
