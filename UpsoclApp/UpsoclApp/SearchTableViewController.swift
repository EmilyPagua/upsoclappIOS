//
//  SearchTableViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 23-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var servicesConnection = ServicesConnection()
    var newsList = [News]()
    var paged = 0
    var filter = ""
    
    var searchActive : Bool = false
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        //loadProgressBar
        indicator = progressBar.loadBar()
        indicator.frame = CGRectMake(200.0, 40.0, 40.0, 40.0)
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
    }
    
    
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = true
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.newsList = [News]()
        searchActive =  false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.newsList = [News]()
        searchActive =  false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.newsList = [News]()
        
        indicator.startAnimating()
        paged = 0
        
        switch paged {
        case 0:
            newsList.removeAll()
            paged = 1
            callWebServices(String(self.paged),searchText: filter)
            searchActive =  true
            
        case 1:
            print ("Es uno")
        default:
            paged = 1
            callWebServices(String(self.paged),searchText: filter)
            searchActive =  true
        }
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchActive =  false
        return searchActive
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filter = searchText
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("CellBookmark")! as UITableViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellSearch") as! NewsViewCell
        
        if (newsList.count != 0 ){
            let news = newsList[indexPath.row]
            cell.postTitleLabel.text = news.titleNews
            loadImage( news.imageURLNews, viewImagen: cell.postImagenView)
            
            if indexPath.row == self.newsList.count - 3 {
                paged += 1
                callWebServices( String (paged), searchText: filter)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func callWebServices(page: String , searchText: String){
                
        let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + ApiConstants.PropertyKey.pageFilter + page + ApiConstants.PropertyKey.filterWord +  searchText
        
        servicesConnection.loadAllNews(self.newsList, urlPath: urlPath, completionHandler: { (moreWrapper, error) in
            self.newsList = moreWrapper!
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                return
            })
        })
    }
    
    func loadImage(urlImage: String?, viewImagen: UIImageView){
        servicesConnection.loadImage(urlImage, completionHandler: { (moreWrapper, error) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                viewImagen.image = moreWrapper
            })
        })
    }
    
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
                
                if indexPath.row + 5 <= listCount {
                    for  i in indexPath.row  ..< indexPath.row + 5   {
                        list.append(newsList[i])
                    }
                    detailViewController.newsList = list
                }
            }
        }
    }
}
