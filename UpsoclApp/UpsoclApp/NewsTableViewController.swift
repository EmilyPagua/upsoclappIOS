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
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //loadProgressBar
        indicator = progressBar.loadBar()
        //indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        
        self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        callWebServices(String(page))
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
            print("ERROR_ Failed to save news...")
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
    // Override to support editing the table view.
   /* override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            newsList.removeAtIndex(indexPath.row)
            saveNews()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }*/

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
            
        if segue.identifier == "ShowDetail" {
            
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
        }
    }
    
    func callWebServices(_ paged: String ){
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            self.indicator.startAnimating()
            
            let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + ApiConstants.PropertyKey.pageFilter + paged
            servicesConnection.loadAllNews(self.newsList, urlPath: urlPath, completionHandler: { (moreWrapper, error) in
                
                self.newsList = moreWrapper!
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    return
                })
            })
        } else {
            print("ERROR_ Internet connection FAILED")
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
