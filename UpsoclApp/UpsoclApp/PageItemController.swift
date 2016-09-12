//
//  PageItemController.swift
//  UpsoclApp
//
//  Created by upsocl on 09-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
    
    var itemIndex: Int = 0
    var contentWeb : String  = ""

    @IBOutlet weak var contentWebView: UIWebView!
    
    let fonts = "<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'><link href='http://fonts.googleapis.com/css?family=Raleway:400,600' rel='stylesheet' type='text/css'>"
    let meta = "<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'>"
    let style = "<link rel='stylesheet' type='text/css' media='all' href='http://www.upsocl.com/wp-content/themes/upso3/style.css'>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentDetail = meta + style + fonts
        
        let baseURL = NSURL(string: "http://api.instagram.com/oembed")
        contentWebView.loadHTMLString(contentDetail, baseURL: baseURL)
    }
    
}
