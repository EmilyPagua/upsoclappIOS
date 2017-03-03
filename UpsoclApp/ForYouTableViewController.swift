//
//  ForYouViewController.swift
//  appupsocl
//
//  Created by upsocl on 07-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ForYouTableViewController: UITableViewController {

    @IBOutlet weak var notificationButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var newsList = [News]()
    var servicesConnection = ServicesConnection()
    var page = 1
    
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var keyCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //loadProgressBar
        indicator = progressBar.loadBar()
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        
         self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        createURL ()
        callWebServices(String(page))
    }
    
    func createURL(){
        
        for elem in UserDefaults.standard.dictionaryRepresentation(){
            
            let key = elem.0
            
            switch key {
            case "culture":
                keyCategory = keyCategory + Category.PropertyKey.cultura + ","
            case "beauty":
                keyCategory = keyCategory + Category.PropertyKey.beauty + ","
            case "colaboration":
                keyCategory = keyCategory + Category.PropertyKey.colaboration + ","
            case "community":
                keyCategory = keyCategory + Category.PropertyKey.community + ","
            case "creativity":
                keyCategory = keyCategory + Category.PropertyKey.creativity + ","
            case "diversity":
                keyCategory = keyCategory + Category.PropertyKey.diversity + ","
            case "family":
                keyCategory = keyCategory + Category.PropertyKey.family + ","
            case "food":
                keyCategory = keyCategory + Category.PropertyKey.food + ","
            case "green":
                keyCategory = keyCategory + Category.PropertyKey.green + ","
            case "health":
                keyCategory = keyCategory + Category.PropertyKey.health + ","
            case "inspiration":
                keyCategory = keyCategory + Category.PropertyKey.inspiration + ","
            case "movies":
                keyCategory = keyCategory + Category.PropertyKey.movies + ","
            case "populary":
                keyCategory = keyCategory + Category.PropertyKey.populary + ","
            case "quiz":
                keyCategory = keyCategory + Category.PropertyKey.quiz + ","
            case "relations":
                keyCategory = keyCategory + Category.PropertyKey.relations + ","
            case "stileLive":
                keyCategory = keyCategory + Category.PropertyKey.styleLive + ","
            case "women":
                keyCategory = keyCategory + Category.PropertyKey.women + ","
            case "world":
                keyCategory = keyCategory + Category.PropertyKey.world + ","
            default: break
                
            }
        }
        
        if (keyCategory.isEmpty){
            keyCategory = keyCategory + Category.PropertyKey.populary + ","
        }
        keyCategory = keyCategory.substring(to: keyCategory.characters.index(before: keyCategory.endIndex))
    }
    
    func handleRefresh(_ resfresControl: UIRefreshControl){
        newsList.removeAll()
        
        page = 1
        callWebServices(String(page))
        refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForYou", for: indexPath) as! NewsViewCell

        // Configure the cell...
        if (newsList.count != 0 ){
            let news = newsList[(indexPath as NSIndexPath).row]
            cell.postTitleLabel.text = news.titleNews
            self.loadImage( news.imageURLNews, viewImagen: cell.postImagenView)
            
            if (indexPath as NSIndexPath).row == self.newsList.count - 3 {
                page += 1
                callWebServices(String (page))
            }
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if (segue.identifier?.isEmpty == false){
            let id = segue.identifier! as String
        switch id {
        case "ShowNotification":
            
            var notification: [PostNotification] = []
            notification = NewsSingleton.sharedInstance.allItems()
            
            if (notification.isEmpty){
                NSLog("No tiene noticaciones disponibles")
            }else{
                self.processingNotification(notification: notification, segue: segue )
                return
            }
            
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
            NSLog ("Es otro boton")
        }
    }
    }

    func callWebServices(_ paged: String ){
        
        self.indicator.startAnimating()
       
        let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + ApiConstants.PropertyKey.filterCategoryName + keyCategory + ApiConstants.PropertyKey.filterPageForYou + paged
       // self.newsList = [News]()
        
        servicesConnection.loadAllNews(self.newsList, urlPath: urlPath, completionHandler: { (moreWrapper, error) in
            
            self.newsList = moreWrapper!
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                return
            })
        })
    }
    
    func loadImage(_ urlImage: String?, viewImagen: UIImageView){
        
        servicesConnection.loadImage(urlImage: urlImage!, completionHandler: { (moreWrapper, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                viewImagen.image = moreWrapper
                self.indicator.stopAnimating()
            })
        })
    }
    
    func processingNotification(notification: [PostNotification], segue: UIStoryboardSegue) -> Void {
        
        let news: News = News(id: (notification.first?.idPost)!,
                              title: (notification.first?.title)!,
                              content: notification.first?.content,
                              imageURL: notification.first?.imageURL,
                              date: notification.first?.date,
                              link: notification.first?.link,
                              category: notification.first?.category,
                              author: notification.first?.author)!
        
        var newsList = [News]()
        newsList.append(news)
        
        var post = notification.first
        post?.isRead  = true
        notificationButton.image = UIImage(named: "notification_disable")
        
        NewsSingleton.sharedInstance.removeAllItem(itemKey: NewsSingleton.sharedInstance.ITEMS_KEY_Notification)
        NewsSingleton.sharedInstance.addNotification(post!)
        
        let detailViewController = segue.destination as! PageViewController
        detailViewController.newsList = newsList
    }
    
}
