//
//  SearchTableViewController.swift
//  appupsocl
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
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.isHidden =  false
        
        //loadProgressBar
        indicator = progressBar.loadBar()
        indicator.frame = CGRect(x: (UIScreen.main.bounds.width/2) - 20, y: 40.0, width: 40.0, height: 40.0)
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.newsList = [News]()
        searchActive =  false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.newsList = [News]()
        searchActive =  false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
            print ("No pertenece")
        default:
            paged = 1
            callWebServices(String(self.paged),searchText: filter)
            searchActive =  true
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchActive =  true
        return searchActive
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filter = searchText
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("CellBookmark")! as UITableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSearch") as! NewsViewCell
        
        if (newsList.count != 0 ){
            let news = newsList[(indexPath as NSIndexPath).row]
            cell.postTitleLabel.text = news.titleNews
            loadImage( news.imageURLNews, viewImagen: cell.postImagenView)
            
            if (indexPath as NSIndexPath).row == self.newsList.count - 3 {
                paged += 1
                callWebServices( String (paged), searchText: filter)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func callWebServices(_ page: String , searchText: String){
                
        let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + ApiConstants.PropertyKey.pageFilter + page + ApiConstants.PropertyKey.filterWord +  searchText
        
        servicesConnection.loadAllNews(self.newsList, urlPath: urlPath, completionHandler: { (moreWrapper, error) in
            
            self.newsList = moreWrapper!
            
            if self.newsList.count == 0 {
                self.displayAlert("Error", message: "No se encotraron post relacionados a: " + searchText )
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.searchBar.endEditing(true)
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
                detailViewController.isSearchResult = true
            }
        }
    }
    
    func displayAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        return
    }
    

}
