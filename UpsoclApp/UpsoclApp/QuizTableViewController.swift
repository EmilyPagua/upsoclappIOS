//
//  QuizTableViewController.swift
//  appupsocl
//
//  Created by upsocl on 08-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class QuizTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    
    var newsList =  [News]()
    var servicesConnection = ServicesConnection()
    var page = 1
    
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //loadProgressBar
        indicator = progressBar.loadBar()
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        
        self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        callWebServices(String (page))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellQuiz", for: indexPath) as! NewsViewCell

        // Configure the cell...
        if (newsList.count != 0 ){
            let news = newsList[(indexPath as NSIndexPath).row]
            cell.postTitleLabel.text = news.titleNews
            loadImage( news.imageURLNews, viewImagen: cell.postImagenView)
        
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            
            let id = segue.identifier! as String
            switch id {
            case "ShowNotification":
                
                var notification: [PostNotification] = []
                notification = NewsSingleton.sharedInstance.allItems()
                
                if (notification.isEmpty){
                    print("No tiene noticaciones disponibles")
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
                    
                    if (indexPath as NSIndexPath).row + 5 <= listCount {
                        for  i in (indexPath as NSIndexPath).row  ..< (indexPath as NSIndexPath).row + 5   {
                            list.append(newsList[i])
                        }
                        detailViewController.newsList = list
                    }
                }
                
            default:
                print ("Indefinido")
            }
        }
    }
    func callWebServices(_ paged: String ){
        
        self.indicator.startAnimating()
        
        let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + ApiConstants.PropertyKey.filterCategoryName + Category.PropertyKey.quiz
        
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
        
        if (urlImage?.isEmpty==false){
            servicesConnection.loadImage(urlImage: urlImage!, completionHandler: { (moreWrapper, error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    viewImagen.image = moreWrapper
                })
            })
        }
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
        
        NewsSingleton.sharedInstance.removeAllItem()
        NewsSingleton.sharedInstance.addNotification(post!)
        
        let detailViewController = segue.destination as! PageViewController
        detailViewController.newsList = newsList
    }
    
}
