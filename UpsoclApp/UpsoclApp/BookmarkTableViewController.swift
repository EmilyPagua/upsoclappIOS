//
//  BookmarkTableViewController.swift
//  appupsocl
//
//  Created by upsocl on 15-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class BookmarkTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var servicesConnection =  ServicesConnection()
    var newsList = [News]()
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadProgressBar
        indicator = progressBar.loadBar()
        //indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadList()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellBookmark", for: indexPath) as! NewsViewCell
         
        // Configure the cell...
        let news = newsList[(indexPath as NSIndexPath).row]
        cell.postTitleLabel.text = news.titleNews
        
        self.loadImage( news.imageURLNews, viewImagen: cell.postImagenView)
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Opciones laterales de boookmark
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let newsPost  = self.newsList[(indexPath as NSIndexPath).row]
        
        let more = UITableViewRowAction(style: .normal, title: "Remover") { action, index in

            
            let item = PostNotification(idPost: (newsPost.idNews),
                                        title: (newsPost.titleNews),
                                        subTitle: (newsPost.titleNews) ,
                                        UUID: UUID().uuidString,
                                        imageURL: (newsPost.imageURLNews) ?? "SinImagen",
                                        date: (newsPost.dateNews) ?? "01-01-2017",
                                        link: (newsPost.linkNews) ,
                                        category: (newsPost.categoryNews) ,
                                        author: (newsPost.authorNews) ?? "Anonimo",
                                        content: (newsPost.contentNews) ?? "",
                                        isRead: false)
            
            NewsSingleton.sharedInstance.removeItem(item: item, isBookmark: true)
            
            
            self.newsList.remove(at: (indexPath as NSIndexPath).row)
            self.saveNews()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        more.backgroundColor = UIColor.lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Compartir") { action, index in
            let objectShare: [String] = [(newsPost.titleNews), (newsPost.linkNews)]
            let activityViewController = UIActivityViewController(activityItems: objectShare, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: {})
        }
        favorite.backgroundColor = UIColor.orange
        return [favorite, more]
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            
            let detailViewController = segue.destination as! PageViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? NewsViewCell {
                let indexPath = tableView.indexPath(for: selectedMealCell)!
                
                var list =  [News]()
                let listCount = newsList.count
                
                if (indexPath as NSIndexPath).row + 2 <= listCount {
                    for  i in (indexPath as NSIndexPath).row  ..< (indexPath as NSIndexPath).row + 2   {
                        list.append(newsList[i])
                    }
                    detailViewController.newsList = list
                }
                else {
                    list.append(newsList[(indexPath as NSIndexPath).row])
                    detailViewController.newsList = list
                }
            }
        }
    }
    
    func loadList() {
        
        let list:[PostNotification] = NewsSingleton.sharedInstance.getAllBookmark()
        
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
    }
    
    func loadImage(_ urlImage: String?, viewImagen: UIImageView){
        
        servicesConnection.loadImage(urlImage: urlImage!, completionHandler: { (moreWrapper, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                viewImagen.image = moreWrapper
                self.indicator.stopAnimating()
            })
        })
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
        } else if editingStyle == .none {
            NSLog ("none")
        }
    }
    
    func saveNews() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newsList, toFile: News.ArchiveURL.path)
        if !isSuccessfulSave {
            NSLog("ERROR_ BookmarkTableViewController SaveNews failed to save news...")
        }
    }
}
 
