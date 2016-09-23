//
//  BookmarkTableViewController.swift
//  UpsoclApp
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
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //loadProgressBar
        indicator = progressBar.loadBar()
        //indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadList()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return newsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellBookmark", forIndexPath: indexPath) as! NewsViewCell
         
        // Configure the cell...
        let news = newsList[indexPath.row]
        cell.postTitleLabel.text = news.titleNews
        
        loadImage( news.imageURLNews, viewImagen: cell.postImagenView)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        // print (tableView.setContentOffset(CGPointMake(0, tableView.rowHeight - tableView.frame.size.height), animated: true))
        return true
    }
    
    //Opciones laterales de boookmark
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .Normal, title: "Remover") { action, index in
            print("Remover")
            
            let preferences = NSUserDefaults.standardUserDefaults()
            let newsPost  = self.newsList[indexPath.row]
            preferences.removeObjectForKey(String(newsPost.idNews))
            preferences.synchronize()
            
            self.newsList.removeAtIndex(indexPath.row)
            self.saveNews()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        more.backgroundColor = UIColor.lightGrayColor()
        
        let favorite = UITableViewRowAction(style: .Normal, title: "Compartir") { action, index in
            print("compartir")
        }
        favorite.backgroundColor = UIColor.orangeColor()
        return [favorite, more]
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetail" {
            
            let detailViewController = segue.destinationViewController as! PageViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? NewsViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                
                var list =  [News]()
                let listCount = newsList.count
                
                if indexPath.row + 2 <= listCount {
                    for  i in indexPath.row  ..< indexPath.row + 2   {
                        list.append(newsList[i])
                    }
                    detailViewController.newsList = list
                }
                else {
                    list.append(newsList[indexPath.row])
                    detailViewController.newsList = list
                }
            }
        }
    }
    
    
    func loadList() {
        
        for elem in NSUserDefaults.standardUserDefaults().dictionaryRepresentation(){
            
            let key = elem.0
            let numberCharacters = NSCharacterSet.decimalDigitCharacterSet().invertedSet
            
            if !key.isEmpty && key.rangeOfCharacterFromSet(numberCharacters) == nil{
                
                let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + "/" + key
                servicesConnection.loadNews(self.newsList, urlPath: urlPath, completionHandler: { (moreWrapper, error) in
                    
                    self.newsList = moreWrapper!
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    return
                    })
                })
            }
        }
    }
    
    func loadImage(urlImage: String?, viewImagen: UIImageView){
        
        servicesConnection.loadImage(urlImage, completionHandler: { (moreWrapper, error) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                viewImagen.image = moreWrapper
                self.indicator.stopAnimating()
            })
        })
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
        } else if editingStyle == .None {
            print ("none")
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func saveNews() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newsList, toFile: News.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save news...")
        }
    }
    
    
}
 