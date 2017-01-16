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
    
    @IBOutlet weak var bookmark: UIBarButtonItem!
    @IBOutlet weak var buttonShareFacebook: UIBarButtonItem!
    
    var servicesConnection = ServicesConnection()
    let baseURL = URL(string: "http://api.instagram.com/oembed")
    
    let top = "<html> <header> " + DetailConstants.PropertyKey.HTML_HEAD + "</header> <body>"
    
     var itemIndex: Int = 0
    var news: News = News(id: 0, title: "", content: "", imageURL: "", date: "", link: "", category: "", author: "")!
    var contentDetail = ""
    var isSearchResult = false
    
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    @IBOutlet weak var contentWebView: UIWebView!
    
    //VAR
    var scrollViewDetail : UIScrollView!
    var webDetail: UIWebView!
    
    var viewCount =  1
    //END  VAR
    
    
    //banner
    lazy var bannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        adBannerView.adUnitID = "ca-mb-app-pub-7682123866908966/2346534963"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
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
        
        self.indicator.startAnimating()
        
        self.bannerView.load(GADRequest())
        
        self.webDetail =  UIWebView()
        self.webDetail.delegate = self
        self.webDetail.loadHTMLString(self.createHTML(), baseURL: self.baseURL)
        self.webDetail.scrollView.isScrollEnabled =  true
        
        self.scrollViewDetail = UIScrollView()
        self.scrollViewDetail.delegate = self
        self.scrollViewDetail.backgroundColor = UIColor.white
        self.scrollViewDetail.autoresizingMask = UIViewAutoresizing.flexibleWidth
    
        scrollViewDetail.addSubview(self.bannerView)
        scrollViewDetail.addSubview(self.webDetail)
        
        view.addSubview(self.scrollViewDetail)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.webDetail.frame =  CGRect(x:0, y:0, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height)
        

        self.scrollViewDetail.contentSize = CGSize(width: webDetail.bounds.size.width,
                                              height:webDetail.bounds.size.height )
        
        self.scrollViewDetail.frame = CGRect(x:10, y:80, width: view.bounds.width-20,
                                             height: view.bounds.height-85)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.indicator.stopAnimating()
        print ("webViewDidFinishLoad")
        
        //create banner
        self.bannerView.frame = CGRect(x:0, y: self.webDetail.scrollView.contentSize.height+10, width: 300, height: 250)
        self.webDetail.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width-20, height: self.webDetail.scrollView.contentSize.height)
        self.uploadWebView(height: self.webDetail.scrollView.contentSize.height )
    
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
    
    //ComeBack
    @IBAction func comeBack(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden =  false
        self.navigationController?.popViewController(animated: true)
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

        let item = PostNotification(idPost: (news.idNews),
                                    title: (news.titleNews),
                                    subTitle: (news.imageURLNews)! ,
                                    UUID: UUID().uuidString,
                                    imageURL: (news.imageURLNews) ?? "SinImagen",
                                    date: (news.dateNews) ?? "01-01-2017",
                                    link: (news.linkNews) ,
                                    category: (news.categoryNews) ,
                                    author: (news.authorNews) ?? "Anonimo",
                                    content: (news.contentNews) ?? "",
                                    isRead: true)
        
        let flag  = NewsSingleton.sharedInstance.getValueById(news.idNews, isBookmark: true)
        if flag {
            
            NewsSingleton.sharedInstance.removeItem(item: item, isBookmark: true)
            self.bookmark.image = UIImage(named: "bookmarkInactive")
            print ("bookmarkInactive")
        }
        else{
            NewsSingleton.sharedInstance.addBookmark(item)
            
            self.bookmark.image = UIImage(named: "bookmarkActive")
            print ("bookmarkActive")
        }
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

        return contentDetail
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("ERROR_ en webView \(error.localizedDescription)");
        self.uploadWebView(height: self.webDetail.scrollView.contentSize.height )
        
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print ("load Content webView")
        return true;
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView){
        self.indicator.startAnimating()
    }
    
    func isBookmark() {
        
        let flag  = NewsSingleton.sharedInstance.getValueById(news.idNews, isBookmark: true)
        if flag {
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
        print ("Banner loaded successfully ")
        
        self.webDetail.scrollView.isScrollEnabled =  false
        self.uploadWebView(height: self.webDetail.scrollView.contentSize.height + self.bannerView.bounds.height)
        
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
    
    func uploadWebView(height: CGFloat) -> Void {
        
        self.scrollViewDetail.contentSize = CGSize(width: webDetail.bounds.size.width,
                                                   height: height + 240)
        
        print ("Modificado tamaño del Scroll")
        print(self.bannerView.frame.height)
        print(self.scrollViewDetail.frame.height)
        print(self.webDetail.scrollView.contentSize.height)
    }
}
