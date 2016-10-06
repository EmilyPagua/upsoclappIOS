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
    let baseURL = NSURL(string: "http://api.instagram.com/oembed")
    
    let top = "<html> <header> <meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'> <link rel='stylesheet' type='text/css' media='all' href='http://www.upsocl.com/wp-content/themes/upso3/style.css'> <link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'> <link href='http://fonts.googleapis.com/css?family=Raleway:400,600' rel='stylesheet' type='text/css'> <script type='text/javascript'>(function() {var useSSL = 'https:' == document.location.protocol;var src = (useSSL ? 'https:' : 'http:') + '//www.googletagservices.com/tag/js/gpt.js';document.write('<scr' + 'ipt src=\"' + src + '\"> </scr' + 'ipt>');})(); </script> <script> var mappingCT = googletag.sizeMapping().addSize([300, 100], [300, 250]). addSize([760, 200], [728, 90]). build(); var mappingCA = googletag.sizeMapping().addSize([300, 100], [300, 250]). addSize([760, 200], [728, 90]). build();  googletag.defineSlot('/100064084/contenidotop', [[300, 250], [728, 90]], 'div-gpt-ad-ct').defineSizeMapping(mappingCT).addService(googletag.pubads());  googletag.defineSlot('/421815048/contenidoabajo', [[300, 250], [728, 90]], 'div-gpt-ad-ca').defineSizeMapping(mappingCA).addService(googletag.pubads());  googletag.pubads().collapseEmptyDivs();  googletag.pubads().enableSyncRendering();googletag.enableServices(); </script> </header> <body>  "
    
    let banner_up  = "<div id='div-gpt-ad-ct' align='center' > <script> googletag.cmd.push(function() { googletag.display('div-gpt-ad-ct') }); </script> </div>"
    let banner_bot = "<div id='div-gpt-ad-ca' align='center' > <script> googletag.cmd.push(function() { googletag.display('div-gpt-ad-ca') }); </script> </div> </body> </html>"
    
    var itemIndex: Int = 0
    var news =  News?()
    var contentDetail = ""
    var isSearchResult = false
    var webViewSize = 0
    
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    @IBOutlet weak var contentWebView: UIWebView!

    var ads: [String: GADAdSize]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = progressBar.loadBar()
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        
        //loadContent()
        loadContentWithHTML()
    }
    
    //ComeBack
    @IBAction func comeBack(sender: UIBarButtonItem) {
        
        self.tabBarController?.tabBar.hidden =  false
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    //Share
    @IBAction func shareButton(sender: UIBarButtonItem) {
        if news == nil{
            // Hide the keyboard
            displayAlert("Error", message: "Error en el post, vuelva a seleccionarlo")
        } else {
            // We have contents so display the share sheet
            displayShareSheet()
        }
    }
    
    //Share
    @IBAction func shareButtonFacebook(sender: UIBarButtonItem) {
        
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: (news?.linkNews)!)
        content.contentTitle = news?.titleNews
        content.contentDescription = "http://www.upsocl.com/"
        content.imageURL = NSURL(string: (news?.imageURLNews)!)
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
    }

    
    func displayShareSheet() {
        
        let objectShare: [String] = [(news?.titleNews)!, (news?.linkNews)!]
        let activityViewController = UIActivityViewController(activityItems: objectShare, applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        return
    }

    
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
            print ("bookmarkActive")
        } else {
            preferences.removeObjectForKey(currentLevelKey)
            bookmark.image = UIImage(named: "bookmarkInactive")
            print ("bookmarkInactive")
        }
        preferences.synchronize()
    }
    
    func loadContentWithHTML(){
        
        if news != nil {
                        
            loadIsBookmark()
            contentDetail = top
            
            if news!.imageURLNews != nil{
                let imagen  = "<center><p><img img align=\"middle\" alt=\"Portada\" class=\"wp-image-480065 size-full\" height=\"605\" itemprop=\"contentURL\" sizes=\"(max-width: 728px) 100vw, 728px\" src="+news!.imageURLNews!+" width=\"728\" > </p></center>"
                contentDetail = contentDetail + imagen
            }
            let line = "<hr  color=\"#009688\" />"
            let title = "<div> <h1 class='entry-title' > "+news!.titleNews+"</h1> </div>"
            let detailAuthor = "<div class='entry-meta socialtop socialextra'>  Autor: <font color=\"#009688\">"+news!.authorNews!+" </font>.  El: <font color=\"#009688\"> "+news!.dateNews!+" </font> "
            let category = " <br/> Categorias: <font color=\"#009688\">"+news!.categoryNews+"</font> </div> "
            let content = news!.contentNews
            
            contentDetail = contentDetail  + title + detailAuthor + category + banner_up
            contentDetail = contentDetail + line + content! + banner_bot
            
            let baseURL = NSURL(string: "http://api.instagram.com/oembed")
            self.webViewContent.loadHTMLString(contentDetail, baseURL: baseURL)
            webViewContent.delegate = self
        }
    }
    
    
    func loadContent() {
        
        if news != nil {
            
            self.webViewContent.scrollView.scrollEnabled = false
            
            loadIsBookmark()
            
            if news!.imageURLNews != nil{
                loadImage(news!.imageURLNews!, viewImagen: imagenDetail)
            }
            
            titleDetail.text = news!.titleNews
            categoryDetail.text = "Autor: " + news!.authorNews! + ". Categoría: " + news!.dateNews!
            authorDetail.text = "Categoría: " + news!.categoryNews
    
            let line = "<hr  color=\"#009688\" />"
            let publicity = ""
            
            if news != nil {
                
                contentDetail = contentDetail + line + publicity + news!.contentNews!
                let baseURL = NSURL(string: "http://api.instagram.com/oembed")
                
                self.webViewContent.loadHTMLString(contentDetail, baseURL: baseURL)
                webViewContent.delegate = self
            }
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("Error en webView \(error?.localizedDescription)");
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //print ("webView")
        return true;
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        self.indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.indicator.stopAnimating()
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
    
    func loadImage(urlImage: String?, viewImagen: UIImageView){
        
        servicesConnection.loadImage(urlImage, completionHandler: { (moreWrapper, error) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                viewImagen.image = moreWrapper
            })
        })
    }
    
    //BannerViewController
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("adView: didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func adViewDidReceiveAd(view: GADBannerView!) {
        print ("adViewDidReceiveAd ")
    }
    
    func adViewWillLeaveApplication(bannerView: GADBannerView!) {
        print ("adViewWillLeaveApplication")
        bannerView.hidden =  false
    }
    func adViewDidDismissScreen(bannerView: GADBannerView!) {
        print ("adViewDidDismissScreen")
        bannerView.hidden =  false
    }
    
    func adViewWillPresentScreen(bannerView: GADBannerView!) {
        print ("adViewDidDismissScreen")
        bannerView.hidden =  false
    }
    //BannerViewController
    
    
    
    //Google Analytics
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        /*let name = news?.linkNews
        print ("----------------" + name!)

        // [START screen_view_hit_swift]
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])*/
        // [END screen_view_hit_swift]

    }
    //End Google Analytics
}
