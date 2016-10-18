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
        
        loadImage( news.imageURLNews, viewImagen: cell.postImagenView)
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        // print (tableView.setContentOffset(CGPointMake(0, tableView.rowHeight - tableView.frame.size.height), animated: true))
        return true
    }
    
    //Opciones laterales de boookmark
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let newsPost  = self.newsList[(indexPath as NSIndexPath).row]
        
        let more = UITableViewRowAction(style: .normal, title: "Remover") { action, index in
            print("Remover")
            
            let preferences = UserDefaults.standard
            //let newsPost  = self.newsList[indexPath.row]
            preferences.removeObject(forKey: String(newsPost.idNews))
            preferences.synchronize()
            
            self.newsList.remove(at: (indexPath as NSIndexPath).row)
            self.saveNews()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        more.backgroundColor = UIColor.lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Compartir") { action, index in
            print("compartir")
            
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
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
        
        for elem in UserDefaults.standard.dictionaryRepresentation(){
            
            let key = elem.0
            let numberCharacters = CharacterSet.decimalDigits.inverted
            
            if !key.isEmpty && key.rangeOfCharacter(from: numberCharacters) == nil{
                
                //let urlPath = ApiConstants.PropertyKey.baseURL + ApiConstants.PropertyKey.listPost + "/" + key
                let urlPath =     "//http://upsocl.com/wp-json/wp/v2/pages/445196"

                
                print (urlPath)
                
                servicesConnection.loadNews(self.newsList, urlPath: urlPath, completionHandler: { (moreWrapper, error) in
                    self.newsList = moreWrapper!
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    return
                    })
                })
            }
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
            print ("none")
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func saveNews() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newsList, toFile: News.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save news...")
        }
    }
}
 
