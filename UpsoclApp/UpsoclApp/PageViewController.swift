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
    var isSearchResult: Bool = false
    
    var item = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden =  true
        self.navigationController?.navigationBarHidden = true

        
        let preferences = NSUserDefaults.standardUserDefaults()
        //let bookmark = newsList[0]
        // let currentLevel = preferences.objectForKey(String(bookmark.idNews))
        
        for  i in 0  ..< newsList.count    {
            let bookmark = newsList[i]
            _ = preferences.objectForKey(String(bookmark.idNews))
        }
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
        
        print (String(itemController.itemIndex) + "  *  " + String (previousIndex) )
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
        
        print (String(itemController.itemIndex) + "  -  " + String (nextIndex))
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
            var pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
            print (itemIndex)
            if itemIndex==0 {
                print (itemIndex)
            }
            
            if itemIndex == 1 {
                pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController2") as! PageItemController
                print (pageItemController)
            }
            
            
            pageItemController.itemIndex =  itemIndex
            pageItemController.news = newsList[itemIndex]
            pageItemController.isSearchResult = isSearchResult
            
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
}


