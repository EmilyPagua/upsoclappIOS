//
//  NewsTableViewController.swift
//  UpsoclApp
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    var newsList = [News]()
    var servicesConnection = ServicesConnection()
    var page =  1
    
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadProgressBar
        indicator = progressBar.loadBar()
        //indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        
        
        self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //self.revealViewController().rearViewRevealWidth = 62
        let newIndexPath = NSIndexPath(forRow: newsList.count, inSection: 0)
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
       
        callWebServices(String(page))
    }
    
    func handleRefresh(resfresControl: UIRefreshControl){
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return newsList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        let news = newsList[indexPath.row]
        cell.postTitleLabel.text = news.titleNews
        cell.authorLabel.text = "Autor: " + news.authorNews!
        cell.categoryLabel.text = "Categoria: " + news.categoryNews
        loadImage( news.imageURLNews, viewImagen: cell.postImageView)
        
        if indexPath.row == self.newsList.count - 2{
            page += 1
            callWebServices(String (page))
        }
        
        return cell
    }

    func saveNews() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newsList, toFile: News.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save news...")
        }
    }
    
    func loadNews() -> [News]? {
        
        var list = NSKeyedUnarchiver.unarchiveObjectWithFile(News.ArchiveURL.path!) as? [News]
        list?.removeAll()
        return list
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
       // print (tableView.setContentOffset(CGPointMake(0, tableView.rowHeight - tableView.frame.size.height), animated: true))
        return true
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            newsList.removeAtIndex(indexPath.row)
            saveNews()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
            
        if segue.identifier == "ShowDetail" {
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? NewsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = newsList[indexPath.row]
                var list =  [News]()
                
                for (var i = indexPath.row ; i < indexPath.row + 5 ; i += 1 ){
                    list.append(newsList[i])
                }
                
                detailViewController.newsList = list
                detailViewController.newsFirst = selectedMeal
            }
        }
    }
    
    func callWebServices(paged: String ){
        
        self.indicator.startAnimating()
        
        let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + ApiConstants.PropertyKey.pageFilter + paged
        servicesConnection.loadNews(self.newsList, urlPath: urlPath, completionHandler: { (moreWrapper, error) in
            
            self.newsList = moreWrapper!
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                return
            })
        })
    }
    
    func loadImage(urlImage: String?, viewImagen: UIImageView){
        
        servicesConnection.loadImage(urlImage, completionHandler: { (moreWrapper, error) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                viewImagen.image = moreWrapper
                self.indicator.stopAnimating()
            })
        })
    }

}
