//
//  CreativityTableViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 08-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class CreativityTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var newsList = [News]()
    var servicesConnection =  ServicesConnection()
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

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCreativity", for: indexPath) as! NewsViewCell
        // Configure the cell...
        if (newsList.count != 0 ){
            let news = newsList[(indexPath as NSIndexPath).row]
            cell.postTitleLabel.text = news.titleNews
            loadImage( news.imageURLNews, viewImagen: cell.postImagenView)
        
            if (indexPath as NSIndexPath).row == self.newsList.count - 3{
                page += 1
                callWebServices(String (page))
            }
        }
        return cell
    }
    

    func callWebServices(_ paged: String ){
        
        self.indicator.startAnimating()
        
        let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + ApiConstants.PropertyKey.filterCategoryName + Category.PropertyKey.creativity
        
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
            })
        })
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetail" {
            
            let detailViewController = segue.destination as! PageViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? NewsViewCell {
                let indexPath = tableView.indexPath(for: selectedMealCell)!
                
                var list =  [News]()
                let listCount = newsList.count
                
                for i in (indexPath as NSIndexPath).row  ..< (indexPath as NSIndexPath).row + 4  {
                    if listCount >= i {
                        list.append(newsList[i])
                    }
                }
                detailViewController.newsList = list
            }
        }
    }
}
