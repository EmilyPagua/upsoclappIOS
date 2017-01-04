//
//  PageItemController.swift
//  appupsocl
//
//  Created by upsocl on 09-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Social
import FBSDKLoginKit
import FBSDKShareKit
import iAd
import GoogleMobileAds

class PageItemController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, GADBannerViewDelegate  {

    
   /* @IBOutlet weak var webViewContent: UIWebView!
    @IBOutlet weak var imagenDetail: UIImageView!
    @IBOutlet weak var titleDetail: UILabel!
    @IBOutlet weak var authorDetail: UILabel!
    @IBOutlet weak var categoryDetail: UILabel!
   */
    
    @IBOutlet weak var bookmark: UIBarButtonItem!
    @IBOutlet weak var buttonShareFacebook: UIBarButtonItem!
    
    var servicesConnection = ServicesConnection()
    let baseURL = URL(string: "http://api.instagram.com/oembed")
    
    let top = "<html> <header> " + DetailConstants.PropertyKey.HTML_HEAD + "</header> <body>"
    
     var itemIndex: Int = 0
    var news: News = News(id: 0, title: "", content: "", imageURL: "", date: "", link: "", category: "", author: "")!
    var contentDetail = ""
    var isSearchResult = false
    var webViewSize = 0
    
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    @IBOutlet weak var contentWebView: UIWebView!
    
    //VAR
    var scrollViewDetail : UIScrollView!
    var containerView: UIView!
    var webDetail: UIWebView!
    var bannerView: GADBannerView!
    
    var viewCount =  1
    //END  VAR
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = progressBar.loadBar()
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)

        self.isBookmark()
        self.createView()
    }
    
    func createView () -> Void{
        
        self.containerView =  UIView()
        self.containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("viewTapped:"))))
        
        self.indicator.startAnimating()
        self.bannerView =  GADBannerView(adSize: kGADAdSizeMediumRectangle)
        self.bannerView.delegate = self
        self.bannerView.adUnitID = "ca-mb-app-pub-7682123866908966/7102497723"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
        self.webDetail =  UIWebView()
        self.webDetail.delegate = self
        self.webDetail.loadHTMLString(self.createHTML(), baseURL: self.baseURL)
        
        self.scrollViewDetail = UIScrollView()
        self.scrollViewDetail.delegate = self
        self.scrollViewDetail.backgroundColor = UIColor.white
        self.scrollViewDetail.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
        self.containerView.addSubview(self.webDetail)
        self.containerView.addSubview(self.bannerView)
    
        scrollViewDetail.addSubview(self.containerView)
        view.addSubview(self.scrollViewDetail)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webDetail.frame =  CGRect(x:0, y:0, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height)
        bannerView.frame = CGRect(x:0, y:webDetail.scrollView.bounds.maxY+10, width: 300, height: 250)

        scrollViewDetail.contentSize = CGSize(width: webDetail.bounds.size.width,
                                              height:webDetail.bounds.size.height + 260.0)
        
        scrollViewDetail.frame = CGRect(x:10, y:80, width: view.bounds.width-20, height: view.bounds.height-82)
        
        containerView.frame = CGRect(x: 0, y: 0,
                                     width: scrollViewDetail.contentSize.width,
                                     height: scrollViewDetail.bounds.size.height)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.indicator.stopAnimating()
        print ("webViewDidFinishLoad")
    }

    
    func plus(sender : UIButton) {
        update(zoomScale: scrollViewDetail.zoomScale+0.1, offSet: CGPoint.zero)
    }
    func minus(sender : UIButton) {
        update(zoomScale: scrollViewDetail.zoomScale-0.1, offSet: CGPoint.zero)
    }

    func update(zoomScale: CGFloat, offSet: CGPoint) {
        scrollViewDetail.zoomScale = zoomScale
        scrollViewDetail.contentOffset = offSet
    }
    
    
    func viewTapped(gesture : UITapGestureRecognizer) {
        if gesture.view == containerView {
            let v = UIView(frame: CGRect(x: 0, y: 0,width: 100, height: 100))
            v.center = gesture.location(in: containerView)
            v.backgroundColor = UIColor.red
            v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("viewTapped:"))))
            addView(view: v, tag: viewCount)
            viewCount = viewCount + 1
        } else {
            deleteView(tag: gesture.view!.tag)
        }
    }
    
    
    func addView (view: UIView, tag: Int) {
        view.tag =  tag
        containerView.addSubview(view)
    }
    
    func deleteView(tag: Int){
        containerView.viewWithTag(tag)?.removeFromSuperview()
        
    }
    
    //ComeBack
    @IBAction func comeBack(_ sender: UIBarButtonItem) {
        
        self.tabBarController?.tabBar.isHidden =  false
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //Share
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        if news.idNews == 0 {
            displayAlert("Error", message: "Error en el post, vuelva a seleccionarlo")
        } else {
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
            self.bookmark.image = UIImage(named: "bookmarkActive")
            print ("bookmarkActive")
        } else {
            preferences.removeObject(forKey: currentLevelKey)
            self.bookmark.image = UIImage(named: "bookmarkInactive")
            print ("bookmarkInactive")
        }
        preferences.synchronize()
    }
    
    
    func createHTML() -> String{
        
        contentDetail = top
        
        if news.imageURLNews != nil{
            let imagen  = " <center><img align=\"middle\" alt=\"Portada\" class=\"wp-image-480065 size-full\" height=\"605\" itemprop=\"contentURL\" sizes=\"(max-width: 728px) 100vw, 728px\" src="+news.imageURLNews!+" width=\"728\" > </center>"
            contentDetail = contentDetail + imagen
        }
        
        let line = "<hr  color=\"#009688\" />"
        let title = "<h2 style=\"text-align: justify;\"><strong> "+news.titleNews+"</strong></h2>"
        let detailAuthor = "<div class='entry-meta socialtop socialextra'>  Autor: <font color=\"#009688\">"+news.authorNews!+" </font>.  El: <font color=\"#009688\"> "+news.dateNews!+" </font> "
        let category = " <br/> Categorias: <font color=\"#009688\">"+news.categoryNews+"</font> </div> "
        var content = news.contentNews
        
        let  result = content?.captureExpression(withRegex: "(class)[=][\"](wp-image-)\\d{6}[\"]")
        content = result
        
        contentDetail = contentDetail  + title + detailAuthor + category
        contentDetail = contentDetail + line + content! + " </body> </html> "
        
        /*contentDetail =  "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"> <html xmlns=\"http://www.w3.org/1999/xhtml\"> <head>  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />  </head> <body>  <div id=\"myDiv\">Hello</div> <script>  var inlineScript   = document.createElement(\"script\"); inlineScript.type  = \"text/javascript\";  inlineScript.text  = '<!--google_ad_client = \"ca-mb-app-pub-7682123866908966\";  google_ad_slot = \"7102497723\";  google_ad_width = 300;  google_ad_height = 250;//-->' document.getElementById(\"myDiv\").appendChild(inlineScript);  var externalScript   = document.createElement(\"script\");  externalScript.type  = \"text/javascript\"; externalScript.src = \"http://pagead2.googlesyndication.com/pagead/show_ads.js\"; document.getElementById(\"myDiv\").appendChild(externalScript);  </script>  </body>  </html>"*/
        return contentDetail
    
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("ERROR_ en webView \(error.localizedDescription)");
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print ("load Content webView")
        
        return true;
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView){
        self.indicator.startAnimating()
    }
    
    func isBookmark() {
        
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
        print("ERROR_ adView: didFailToReceiveAdWithError: \(error.localizedDescription)")
        bannerView.isHidden = true
    }
    
    func adViewDidReceiveAd(_ view: GADBannerView) {
        print ("adViewDidReceiveAd ")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print ("adViewWillLeaveApplication")
        bannerView.isHidden =  false
    }
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print ("adViewDidDismissScreen")
        bannerView.isHidden =  false
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print ("adViewDidDismissScreen")
        bannerView.isHidden =  false
    }
    //BannerViewController
}
