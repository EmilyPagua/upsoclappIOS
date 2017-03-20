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
    
    var servicesConnection = ServicesConnection()
    let baseURL = URL(string: "http://api.instagram.com/oembed")
    
    let top = "<html> <header>" + DetailConstants.PropertyKey.HTML_HEAD + "</header> <body>"
    
    var itemIndex: Int = 0
    var news: News = News(id: 0, title: "", content: "", imageURL: "", date: "", link: "", category: "", author: "")!
    var contentDetail = ""
    var isLoadBanner =  false
    var contentViewHtml: String?
    
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
        self.contentViewHtml = self.createHTML()
        
        self.isBookmark()
        self.createView()
        
        if (itemIndex==2){
            self.scrollViewDetail.reloadInputViews()
        }
    }
    
 
    func createView () -> Void{
        print ("createView ")
        
        self.bannerView.load(GADRequest())
        
        self.webDetail =  UIWebView()
        self.webDetail.delegate = self
        
        self.webDetail.loadHTMLString(self.contentViewHtml!, baseURL: self.baseURL)
        
        self.webDetail.scrollView.isScrollEnabled =  true
        
        self.scrollViewDetail = UIScrollView()
        self.scrollViewDetail.delegate = self
        self.scrollViewDetail.backgroundColor = UIColor.white
        self.scrollViewDetail.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
        self.scrollViewDetail.addSubview(self.webDetail)
        
        self.indicator = progressBar.loadBar()
        
        view.addSubview(self.indicator)
        view.addSubview(self.scrollViewDetail)
        
        self.indicator.bringSubview(toFront: view)
        self.indicator.startAnimating()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.indicator.frame = CGRect(x: (UIScreen.main.bounds.width/2) - 10,
                                      y: 70.0,
                                      width: 5,
                                      height: 5)
        
        self.webDetail.frame =  CGRect(x:0,
                                       y:0,
                                       width: UIScreen.main.bounds.width-20,
                                       height: (UIScreen.main.bounds.height * 3))
    
        self.scrollViewDetail.contentSize = CGSize(width: webDetail.bounds.size.width,
                                                   height: webDetail.bounds.size.height + 10)
        
        self.scrollViewDetail.frame = CGRect(x:10,
                                             y:80,
                                             width: view.bounds.width-20,
                                             height: view.bounds.height-85)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        NSLog("webViewDidFinishLoad ")
        self.uploadWebView()
    }
    
    //ComeBack
    @IBAction func comeBack(_ sender: UIBarButtonItem) {
        self.createBarMenu()
    }
    
    func createBarMenu() -> Void {
        
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
                                    date: (news.dateNews) ?? "2017-01-01",
                                    link: (news.linkNews) ,
                                    category: (news.categoryNews) ,
                                    author: (news.authorNews) ?? "Anonimo",
                                    content: (news.contentNews) ?? "",
                                    isRead: true)
        
        let user: [UserLogin] = UserSingleton.sharedInstance.getUserLogin()
            
        if (user.first?.isLogin == true &&  (user.first?.email.isEmpty)!) {
            
            let popup = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "LoginUserController") as! LoginUserController
            self.addChildViewController(popup)
            popup.view.frame = self.view.frame
            popup.isBookmark = true
            popup.postNotification = item
            popup.messageLabel.text =  "Debe inicial sesión para guardar el post como favorito."
            popup.nextButton.setTitle("Cerrar", for: .normal)
            
            self.view.addSubview(popup.view)
            popup.didMove(toParentViewController: self)
            
        }else{
            let flag  = NewsSingleton.sharedInstance.getValueById(news.idNews, isBookmark: true)
            if flag {
                NewsSingleton.sharedInstance.removeItem(item: item, isBookmark: true)
                self.bookmark.image = UIImage(named: "bookmarkInactive")
            }
            else{
                NewsSingleton.sharedInstance.addBookmark(item)
                self.bookmark.image = UIImage(named: "bookmarkActive")
            }
        }
    }
    
    
    func createHTML() -> String{
        
        contentDetail = top
        
        if news.imageURLNews != nil{
            let imagen  = " <center><img align=\"middle\" alt=\"Portada\" class=\"wp-image-480065 size-full\" height=\"605\" itemprop=\"contentURL\" sizes=\"(max-width: 728px) 100vw, 728px\" src="+news.imageURLNews!+" width=\"728\" > </center>"
            contentDetail = contentDetail + imagen
        }
        
        var date = news.dateNews!
        date = date.substring(to:date.index(date.startIndex, offsetBy: 10))
        let line = "<hr  color=\"#009688\" />"
        let title = "<h2 style=\"text-align: justify;\"><strong> "+news.titleNews+"</strong></h2>"
        let detailAuthor = "<div class='entry-meta socialtop socialextra'>  Autor: <font color=\"#009688\">"+news.authorNews!+" </font>.  El: <font color=\"#009688\"> "+date+" </font> "
        let category = " <br/> Categorias: <font color=\"#009688\">"+news.categoryNews+"</font> </div> "
        var content = news.contentNews
        
        //Replace value imagen for  imagen full
        let  result = content?.captureExpression(withRegex: "(class)[=][\"](wp-image-)\\d{6}[\"]", replace: "class=\"wp-image-511029 size-full\" ")
        content = result
     
        contentDetail = contentDetail  + title + detailAuthor + category
        contentDetail = contentDetail + line + content! + " </body> </html> "

        return contentDetail
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        NSLog("ERROR_ en webView \(error.localizedDescription)");
        self.uploadWebView()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true;
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView){
       // NSLog("indicator animation")
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
   func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        NSLog("ERROR_ adView: didFailToReceiveAdWithError: \(error.localizedDescription)")
        self.bannerView.isHidden = true
    }
    
    func adViewDidReceiveAd(_ view: GADBannerView) {
        self.isLoadBanner =  true
        self.uploadWebView()
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        NSLog ("adViewWillLeaveApplication")
        bannerView.isHidden =  false
    }
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        NSLog ("adViewDidDismissScreen")
        bannerView.isHidden =  false
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        NSLog ("adViewDidDismissScreen")
        bannerView.isHidden =  false
    }
    
    func uploadWebView() -> Void {
        
        self.webDetail.scrollView.isScrollEnabled =  false
        
        var frameWebView: CGRect = webDetail.frame
        
        frameWebView.size.width = UIScreen.main.bounds.width-20
        frameWebView.size.height = 1
        
        self.webDetail.frame =  CGRect(x:0,
                                       y:0,
                                       width: UIScreen.main.bounds.width-20,
                                       height: 1)
        
        frameWebView.size.height = self.webDetail.scrollView.contentSize.height+30
        self.webDetail.frame =  frameWebView
        
        var height = frameWebView.size.height
        
        if (self.isLoadBanner && news.categoryNews != "Quiz" && self.webDetail.isLoading == false  && self.webDetail.frame.height != 1)
        {
            self.bannerView.frame = CGRect(x:0, y: self.webDetail.scrollView.contentSize.height-10, width: 300, height: 250)
            self.scrollViewDetail.addSubview(self.bannerView)
            height=height+260
        }
        
        self.scrollViewDetail.contentSize = CGSize(width: self.webDetail.bounds.size.width,
                                                   height: height)
        self.indicator.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!animated){
            self.webDetail.loadHTMLString(self.contentViewHtml!, baseURL: self.baseURL)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //print("Animate  \(animated)  itemIndex \(itemIndex)")
        
    }
    
}
