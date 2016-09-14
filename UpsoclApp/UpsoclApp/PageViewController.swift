//
//  PageViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 12-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource  {

    var newsList = [News]()
    var pageViewController: UIPageViewController?
    
    @IBAction func comeBack(sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.hidden =  false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var saveBookmarkButton: UIBarButtonItem!
    @IBAction func saveBookmark(sender: UIBarButtonItem) {
        
        let position = currentControllerIndex()
        print ("positionBookmark: " + String (position))
        
        let newsBokmark = newsList[position]
        let preferences = NSUserDefaults.standardUserDefaults()
        let currentLevelKey = String(newsBokmark.idNews)
        let currentLevel = preferences.objectForKey(currentLevelKey)
        
        if currentLevel == nil {
            
            let objectJson: NSMutableDictionary =  NSMutableDictionary()
            objectJson.setValue(newsBokmark.idNews, forKey: News.PropertyKey.idKey)
            objectJson.setValue(newsBokmark.titleNews, forKey: News.PropertyKey.titleKey)
            objectJson.setValue(newsBokmark.imageURLNews, forKey: News.PropertyKey.imageURLKey)
            objectJson.setValue(newsBokmark.authorNews, forKey: News.PropertyKey.authorKey)
            objectJson.setValue(newsBokmark.categoryNews, forKey: News.PropertyKey.categoryKey)
            objectJson.setValue(newsBokmark.linkNews, forKey: News.PropertyKey.linkKey)
            objectJson.setValue(newsBokmark.contentNews, forKey: News.PropertyKey.contentKey)
            
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(objectJson, options: NSJSONWritingOptions())
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            
            preferences.setValue(jsonString, forKey: currentLevelKey )
            preferences.synchronize()
            
            //saveBookmarkButton.title = "esBoo"
            saveBookmarkButton.image = UIImage(named: "bookmarkActive")
        } else {
            preferences.removeObjectForKey(currentLevelKey)
            //saveBookmarkButton.title = "Book"
            saveBookmarkButton.image = UIImage(named: "bookmarkInactive")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden =  true
        createPageViewController()
        setupPagecontrol()
    }
    
    
    func createPageViewController (){
        
        let pageController =  self.storyboard?.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if newsList.count > 0 {
            
            let firstController  =  getItemController(0)!
            let startingViewcontroller =  [firstController]
            pageController.setViewControllers(startingViewcontroller, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        loadIsBookmark()
        pageViewController =  pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    func setupPagecontrol(){
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        let previousIndex = itemController.itemIndex - 1
        
        guard previousIndex >= 0 else{
            return nil
        }
        
        guard newsList.count > previousIndex else {
            return nil
        }
        return getItemController(previousIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageItemController
        
        
        let nextIndex = itemController.itemIndex + 1
        let orderedVireControllersCount = newsList.count
        
        guard orderedVireControllersCount != nextIndex else{
            return nil
        }
        
        guard orderedVireControllersCount > nextIndex else {
            return nil
        }
        
        return getItemController(nextIndex)
    }
    
    
    func getItemController (itemIndex: Int) -> PageItemController? {
        if itemIndex < newsList.count{
            
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
            pageItemController.itemIndex =  itemIndex
            pageItemController.news = newsList[itemIndex]
            
            //newsBokmark = newsList[itemIndex]
            
            return pageItemController
        }else { print ("itemIndex > newsList.count")}
        return nil
    }
    
    // MARK: - Page Indicator
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return newsList.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Additions
    func currentControllerIndex() -> Int {
        
        let pageItemController = self.currentController()
        
        if let controller = pageItemController as? PageItemController {
            return controller.itemIndex
        }
        
        return -1
    }
    
    func currentController() -> UIViewController? {
        
        if self.pageViewController?.viewControllers?.count > 0 {
            return self.pageViewController?.viewControllers![0]
        }
        
        return nil
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetail" {
            
            _ = segue.destinationViewController as! PageViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? NewsTableViewCell {
                
            }
        }
    }*/
    
    func loadIsBookmark(){

        let position = currentControllerIndex()
        print ("position: " + String (position))

        if position != -1{
            
            let preferences = NSUserDefaults.standardUserDefaults()
            let bookmark = newsList[position]
            let currentLevel = preferences.objectForKey(String(bookmark.idNews))
            
            self.title = String(bookmark.idNews)
            
            if currentLevel != nil{
                print (String(bookmark.idNews) + "  bookmarkActive")
                saveBookmarkButton.image = UIImage(named: "bookmarkActive")
            }else{
                print ("bookmarkInactive")
                saveBookmarkButton.image = UIImage(named: "bookmarkInactive")
            }
        }
    }
}


