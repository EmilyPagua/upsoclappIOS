//
//  PageViewController.swift
//  appupsocl
//
//  Created by upsocl on 12-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

import Google

class PageViewController: UIViewController, UIPageViewControllerDataSource  {

    var newsList = [News]()
    var pageViewController: UIPageViewController?
    var isSearchResult: Bool = false
    var isNotificaction: Bool = false
    
    var item = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden =  true
        self.navigationController?.isNavigationBarHidden = true
        
        if (isNotificaction){
            self.navigationItem.title =  "Post Destacado"
        }
        
        if (newsList.count==0){
            self.tabBarController?.tabBar.isHidden =  false
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false
        }else{
            for  i in 0  ..< newsList.count    {
                let flag  = NewsSingleton.sharedInstance.getValueById(newsList[i].idNews, isBookmark: true)
                if flag {
                    NSLog ("IsBookmark")
                }
            }
            createPageViewController()
            setupPagecontrol()
        }
    }
    
    
    func createPageViewController (){
        
        let pageController =  self.storyboard?.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if newsList.count > 0 {
            let firstController  =  getItemController(0)!
            let startingViewcontroller =  [firstController]
            pageController.setViewControllers(startingViewcontroller, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController =  pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
    }
    
    func setupPagecontrol(){
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.white
        appearance.currentPageIndicatorTintColor = UIColor.blue
        appearance.backgroundColor = UIColor.lightGray
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
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
    
    
    func getItemController (_ itemIndex: Int) -> PageItemController? {
        
        if itemIndex < newsList.count{
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemController") as! PageItemController
            pageItemController.itemIndex =  itemIndex
            pageItemController.news = newsList[itemIndex]
            pageItemController.isSearchResult = isSearchResult
            
            return pageItemController
            
        }else {
            NSLog ("itemIndex > newsList.count")
        }
        return nil
    }
    
    // MARK: - Page Indicator
   func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return newsList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
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
    
    
    //Google Analytics
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (newsList.count>1){
            let name = newsList[0].linkNews
            NSLog("URL articlo a compartir en GAnalytics:  \(name)")
            
            /*
             DESCOMENTAR PARA QUE SE ENVIEN A GOOGLE ANALYTICS
             
             let googleAnalytics : GAITracker = GAI.sharedInstance().tracker(withTrackingId: ApiConstants.PropertyKey.googleAnalyticsTrackingId)
             GAI.sharedInstance().trackUncaughtExceptions = true
             GAI.sharedInstance().dispatchInterval =  20
             
             googleAnalytics.set(kGAIScreenName, value: "pruebaIOS")
             
             let builder = GAIDictionaryBuilder.createScreenView()
             googleAnalytics.send(builder!.build() as [NSObject : AnyObject])*/
        }else{
            NSLog ("-- GoogleAnalytics, NO se encontro news")
        }
        
        
    }
    //End Google Analytics
}


