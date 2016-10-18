//
//  PageItemController.swift
//  UpsoclApp
//
//  Created by upsocl on 09-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Social
import FBSDKLoginKit
import FBSDKShareKit
import GoogleMobileAds
import iAd

class PageItemController: UIViewController, UIWebViewDelegate, GADBannerViewDelegate {
    //Banner
    
    @IBOutlet weak var webViewContent: UIWebView!
    @IBOutlet weak var imagenDetail: UIImageView!
    @IBOutlet weak var titleDetail: UILabel!
    @IBOutlet weak var authorDetail: UILabel!
    @IBOutlet weak var bookmark: UIBarButtonItem!

    @IBOutlet weak var categoryDetail: UILabel!
    @IBOutlet weak var buttonShareFacebook: UIBarButtonItem!
    
    
    var servicesConnection = ServicesConnection()
    let baseURL = URL(string: "http://api.instagram.com/oembed")
    
    let top = "<html> <header> <meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'> <link rel='stylesheet' type='text/css' media='all' href='http://www.upsocl.com/wp-content/themes/upso3/style.css'> <link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'> <link href='http://fonts.googleapis.com/css?family=Raleway:400,600' rel='stylesheet' type='text/css'> <script type='text/javascript'>(function() {var useSSL = 'https:' == document.location.protocol;var src = (useSSL ? 'https:' : 'http:') + '//www.googletagservices.com/tag/js/gpt.js';document.write('<scr' + 'ipt src=\"' + src + '\"> </scr' + 'ipt>');})(); </script> <script> var mappingCT = googletag.sizeMapping().addSize([300, 100], [300, 250]). addSize([760, 200], [728, 90]). build(); var mappingCA = googletag.sizeMapping().addSize([300, 100], [300, 250]). addSize([760, 200], [728, 90]). build(); googletag.defineSlot('/100064084/contenidotop', [[300, 250], [728, 90]], 'div-gpt-ad-ct').defineSizeMapping(mappingCT).addService(googletag.pubads());  googletag.defineSlot('/100064084/contenidoabajo', [[300, 250], [728, 90]], 'div-gpt-ad-ca').defineSizeMapping(mappingCA).addService(googletag.pubads());  googletag.pubads().collapseEmptyDivs();  googletag.pubads().enableSyncRendering();googletag.enableServices(); </script> </header> <body>  "
    
    let banner_up  = "<div id='div-gpt-ad-ct' align='center' > <script> googletag.cmd.push(function() { googletag.display('div-gpt-ad-ct') }); </script> </div>"
    let banner_bot = "<div id='div-gpt-ad-ca' align='center' > <script> googletag.cmd.push(function() { googletag.display('div-gpt-ad-ca') }); </script> </div> </body> </html>"
    
    ///Users/upsocl/XcodeProjects/upsoclappIOS/UpsoclApp/UpsoclApp/PageItemController.swift:39:9: Stored property 'news' without initial value prevents synthesized initializers
    var itemIndex: Int = 0
    var news: News = News(id: 0, title: "", content: "", imageURL: "", date: "", link: "", category: "", author: "")!
    var contentDetail = ""
    var isSearchResult = false
    var webViewSize = 0
    
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    @IBOutlet weak var contentWebView: UIWebView!

    var ads: [String: GADAdSize]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = progressBar.loadBar()
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        
        //loadContent()
        loadContentWithHTML()
    }
    
    //ComeBack
    @IBAction func comeBack(_ sender: UIBarButtonItem) {
        
        self.tabBarController?.tabBar.isHidden =  false
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //Share
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        if news.idNews == 0 {
            // Hide the keyboard
            displayAlert("Error", message: "Error en el post, vuelva a seleccionarlo")
        } else {
            // We have contents so display the share sheet
            displayShareSheet()
        }
    }
    
    //Share
    @IBAction func shareButtonFacebook(_ sender: UIBarButtonItem) {
        
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = URL(string: (news.linkNews))
        content.contentTitle = news.titleNews
        content.contentDescription = "http://www.upsocl.com/"
        content.imageURL = URL(string: (news.imageURLNews)!)
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
    }

    
    func displayShareSheet() {
        
        let objectShare: [String] = [(news.titleNews), (news.linkNews)]
        let activityViewController = UIActivityViewController(activityItems: objectShare, applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    func displayAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        return
    }

    
    @IBAction func bookmarkButton(_ sender: UIBarButtonItem) {

        let preferences = UserDefaults.standard
        let currentLevelKey = String(news.idNews)
        let currentLevel = preferences.object(forKey: currentLevelKey)
        
        if currentLevel == nil {
            
            let objectJson: NSMutableDictionary =  NSMutableDictionary()
            objectJson.setValue(news.idNews, forKey: News.PropertyKey.idKey)
            objectJson.setValue(news.titleNews, forKey: News.PropertyKey.titleKey)
            objectJson.setValue(news.imageURLNews, forKey: News.PropertyKey.imageURLKey)
            objectJson.setValue(news.authorNews, forKey: News.PropertyKey.authorKey)
            objectJson.setValue(news.categoryNews, forKey: News.PropertyKey.categoryKey)
            objectJson.setValue(news.linkNews, forKey: News.PropertyKey.linkKey)
            objectJson.setValue(news.contentNews, forKey: News.PropertyKey.contentKey)
            
            let jsonData = try! JSONSerialization.data(withJSONObject: objectJson, options: JSONSerialization.WritingOptions())
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as! String
            
            preferences.setValue(jsonString, forKey: currentLevelKey )            
            bookmark.image = UIImage(named: "bookmarkActive")
            print ("bookmarkActive")
        } else {
            preferences.removeObject(forKey: currentLevelKey)
            bookmark.image = UIImage(named: "bookmarkInactive")
            print ("bookmarkInactive")
        }
        preferences.synchronize()
    }
    
    func loadContentWithHTML(){
        
        if news != nil {
                        
            loadIsBookmark()
            contentDetail = top
            
            if news.imageURLNews != nil{
                let imagen  = "<center><img align=\"middle\" alt=\"Portada\" class=\"wp-image-480065 size-full\" height=\"605\" itemprop=\"contentURL\" sizes=\"(max-width: 728px) 100vw, 728px\" src="+news.imageURLNews!+" width=\"728\" > </center>"
                contentDetail = contentDetail + imagen
            }
            let line = "<hr  color=\"#009688\" />"
            let title = "<h2 style=\"text-align: justify;\"><strong> "+news.titleNews+"</strong></h2>"
            let detailAuthor = "<div class='entry-meta socialtop socialextra'>  Autor: <font color=\"#009688\">"+news.authorNews!+" </font>.  El: <font color=\"#009688\"> "+news.dateNews!+" </font> "
            let category = " <br/> Categorias: <font color=\"#009688\">"+news.categoryNews+"</font> </div> "
            let content = news.contentNews
            
            contentDetail = contentDetail  + title + detailAuthor + category + banner_up
            contentDetail = contentDetail + line + content! + banner_bot
            
            //print(contentDetail)
            
            let baseURL = URL(string: "http://api.instagram.com/oembed")
            self.webViewContent.loadHTMLString(contentDetail, baseURL: baseURL)
            webViewContent.delegate = self
        }
    }
    
    func loadContent() {
        
        if news != nil {
            
            self.webViewContent.scrollView.isScrollEnabled = false
            
            loadIsBookmark()
            
            if news.imageURLNews != nil{
                loadImage(news.imageURLNews!, viewImagen: imagenDetail)
            }
            
            titleDetail.text = news.titleNews
            categoryDetail.text = "Autor: " + news.authorNews! + ". Categoría: " + news.dateNews!
            authorDetail.text = "Categoría: " + news.categoryNews
    
            let line = "<hr  color=\"#009688\" />"
            let publicity = ""
            contentDetail = contentDetail + line + publicity + news.contentNews!
                
            let baseURL = URL(string: "http://api.instagram.com/oembed")
            
            self.webViewContent.loadHTMLString(contentDetail, baseURL: baseURL)
            webViewContent.delegate = self
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Error en webView \(error.localizedDescription)");
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //print ("webView")
        return true;
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        self.indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.indicator.stopAnimating()
    }
    
    func loadIsBookmark() {
        
        let preferences = UserDefaults.standard
        let currentLevel = preferences.object(forKey: String(news.idNews))
        
        if currentLevel != nil{
            bookmark.image = UIImage(named: "bookmarkActive")
        }else{
            bookmark.image = UIImage(named: "bookmarkInactive")
        }
    }
    
    func loadImage(_ urlImage: String?, viewImagen: UIImageView){
        
        servicesConnection.loadImage(urlImage: urlImage!, completionHandler: { (moreWrapper, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                viewImagen.image = moreWrapper
            })
        })
    }
    
    //BannerViewController
    func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("adView: didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func adViewDidReceiveAd(_ view: GADBannerView!) {
        print ("adViewDidReceiveAd ")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView!) {
        print ("adViewWillLeaveApplication")
        bannerView.isHidden =  false
    }
    func adViewDidDismissScreen(_ bannerView: GADBannerView!) {
        print ("adViewDidDismissScreen")
        bannerView.isHidden =  false
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView!) {
        print ("adViewDidDismissScreen")
        bannerView.isHidden =  false
    }
    //BannerViewController
    
    
    
    //Google Analytics
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //End Google Analytics
}
