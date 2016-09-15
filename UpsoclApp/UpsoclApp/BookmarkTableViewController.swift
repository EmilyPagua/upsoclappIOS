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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BookmarkTableViewCell
        
        // Configure the cell...
        let news = newsList[indexPath.row]
        cell.postTitleLabel.text = news.titleNews
        cell.postAuthoLabel.text = "Autor: " + news.authorNews!
        cell.postCategoryLabel.text = "Categoria: " + news.categoryNews
        loadImage( news.imageURLNews, viewImagen: cell.postImagenView)
        
        return cell
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
}
 