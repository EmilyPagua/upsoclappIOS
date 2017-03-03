//
//  NewsTableViewController.swift
//  appupsocl
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    
    var newsList = [News]()
    var newsNotification = [News]()
    var servicesConnection = ServicesConnection()
    var page =  1
    
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notification = NewsSingleton.sharedInstance.allItems()
        
        if (notification.isEmpty){
            self.notificationButton.image = UIImage(named: "notification_disable")
            self.notificationButton.isEnabled =  false
        }else{
            if (notification.first?.isRead)!{
                notificationButton.image = UIImage(named: "notification_disable")
                self.notificationButton.isEnabled =  true
            }else{
                notificationButton.image = UIImage(named: "notification_enable")
                self.notificationButton.isEnabled =  true
            }
        }
        self.loadingView()
    }
    
    func loadingView(){
        
        let list:[PostNotification] = NewsSingleton.sharedInstance.get10FisrtNews()
        
        for elem in list {
            let news: News = News(id: (elem.idPost),
                                  title: (elem.title),
                                  content: elem.content,
                                  imageURL: elem.imageURL,
                                  date: elem.date,
                                  link: elem.link,
                                  category: elem.category,
                                  author: elem.author)!
            
            self.newsList.append(news)
            self.tableView.reloadData()
        }
        
        self.indicator = progressBar.loadBar()
        view.addSubview(indicator)
        self.indicator.bringSubview(toFront: view)
        
        self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.callWebServices(String(page))
        
    }
    
    func handleRefresh(_ resfresControl: UIRefreshControl){
        self.newsList.removeAll()
        self.loadingView()

        self.page = 1
        refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsViewCell
        
        // Configure the cell...
        if (newsList.count != 0 ){
            let news = newsList[(indexPath as NSIndexPath).row]
            
            if news.imageURLNews?.isEmpty==false {
                cell.postTitleLabel.text = news.titleNews
                loadImage(urlImage: news.imageURLNews!, viewImagen: cell.postImagenView)
                
                if (indexPath as NSIndexPath).row == self.newsList.count - 3 {
                    page += 1
                    callWebServices(String (page))
                }
            }
        }
        return cell
    }

    func saveNews() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newsList, toFile: News.ArchiveURL.path)
        if !isSuccessfulSave {
            NSLog("ERROR_ Failed to save news...")
        }
    }
    
    func loadNews() -> [News]? {
        
        var list = NSKeyedUnarchiver.unarchiveObject(withFile: News.ArchiveURL.path) as? [News]
        list?.removeAll()
        return list
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
       // print (tableView.setContentOffset(CGPointMake(0, tableView.rowHeight - tableView.frame.size.height), animated: true))
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if (segue.identifier?.isEmpty == false){
            let id = segue.identifier! as String
            switch id {
            case "ShowNotification":
                
                var notification: [PostNotification] = []
                notification = NewsSingleton.sharedInstance.allItems()
                
                if (notification.isEmpty){
                    NSLog("No tiene noticaciones disponibles")
                    notificationButton.image = UIImage(named: "notification_disable")
                }
                self.processingNotification(notification: notification, segue: segue )
                
            case "ShowDetail":
                let detailViewController = segue.destination as! PageViewController
                
                // Get the cell that generated this segue.
                if let selectedMealCell = sender as? NewsViewCell {
                    let indexPath = tableView.indexPath(for: selectedMealCell)!
                    
                    var list =  [News]()
                    let listCount = newsList.count
                    let position = (indexPath as NSIndexPath).row
                    
                    if (position <= listCount) {
                        var showPost = listCount-position
                        if (showPost > 5){
                            showPost = 5
                        }
                        
                        for  i in position ..< position + showPost  {
                            list.append(newsList[i])
                        }
                        detailViewController.newsList = list
                    }
                }
                
            default:
                NSLog ("Indefinido")
                
            }
        }
    }
    
    func processingNotification(notification: [PostNotification], segue: UIStoryboardSegue) -> Void {
        
        if (notification.isEmpty == false ){
            var newsList = [News]()
            let news: News = News(id: (notification.first?.idPost)!,
                              title: (notification.first?.title)!,
                              content: notification.first?.content,
                              imageURL: notification.first?.imageURL,
                              date: notification.first?.date,
                              link: notification.first?.link,
                              category: notification.first?.category,
                              author: notification.first?.author)!
            newsList.append(news)
            var post = notification.first
            post?.isRead  = true
            NewsSingleton.sharedInstance.removeAllItem(itemKey: NewsSingleton.sharedInstance.ITEMS_KEY_Notification)
            NewsSingleton.sharedInstance.addNotification(post!)
            let detailViewController = segue.destination as! PageViewController
            detailViewController.newsList = newsList
            detailViewController.isNotificaction =  true
        }
    }
    
    
    func callWebServices(_ paged: String ){
        
        if Reachability.isConnectedToNetwork() == true {
            
            self.indicator.startAnimating()

            let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + ApiConstants.PropertyKey.pageFilter + paged
           
            servicesConnection.loadAllNews(self.newsList, urlPath: urlPath, completionHandler: { (moreWrapper, error) in
                
               // list = moreWrapper!
                self.newsList = moreWrapper!
                DispatchQueue.main.async(execute: {
                    
                    if (paged=="1" && self.newsList.count > 10){
                        self.newsList.removeSubrange(0..<10)
                        
                        NewsSingleton.sharedInstance.removeAllItem(itemKey: NewsSingleton.sharedInstance.ITEMS_KEY_10NEWS)
                        
                        for  i in 0  ..< 10 {
                            let item = PostNotification(idPost: (self.newsList[i].idNews),
                                                        title: (self.newsList[i].titleNews),
                                                        subTitle: (self.newsList[i].titleNews) ,
                                                        UUID: UUID().uuidString,
                                                        imageURL: (self.newsList[i].imageURLNews) ?? "SinImagen",
                                                        date: (self.newsList[i].dateNews) ?? "01-01-2017",
                                                        link: (self.newsList[i].linkNews) ,
                                                        category: (self.newsList[i].categoryNews) ,
                                                        author: (self.newsList[i].authorNews) ?? "Anonimo",
                                                        content: (self.newsList[i].contentNews) ?? "",
                                                        isRead: false)
                            
                            NewsSingleton.sharedInstance.save10FisrtNews(item)
                        }
                    }
                    self.tableView.reloadData()
                    return
                })
                
            })
        } else {
            NSLog("ERROR_ Internet connection FAILED")
            let alert = UIAlertView(title: "Error!", message: "Verifique su conexión a dato..!", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func loadImage(urlImage: String, viewImagen: UIImageView){
       
            servicesConnection.loadImage(urlImage: urlImage, completionHandler: { (moreWrapper, error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    viewImagen.image = moreWrapper
                    self.indicator.stopAnimating()
                })
            })
    }
    
    
    @IBAction func unwindToNewsList(_ sender: UIStoryboardSegue) {
        self.tabBarController?.tabBar.isHidden =  false
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
