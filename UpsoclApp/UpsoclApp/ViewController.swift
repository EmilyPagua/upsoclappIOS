//
//  ViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 09-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController?
    var webViewContentList = [String]()  //content web
    var newsList =  [News]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
        setupPagecontrol()
        
    }
    
    func createPageViewController (){
        
        let pageController =  self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        if webViewContentList.count > 0 {
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
    func loadContent (){
        
        for (var i = 0 ; i < 3 ; i += 1 ){
            print (i)
            webViewContentList.append("<b>hola</b>")
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex > 0{
            return getItemController(itemController.itemIndex - 1)
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex + 1 > webViewContentList.count{
            return getItemController(itemController.itemIndex + 1)
        }
        
        return nil
    }
    
    func getItemController (itemIndex: Int) -> PageItemController? {
        if itemIndex < webViewContentList.count{
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
            pageItemController.itemIndex =  itemIndex
            pageItemController.contentWeb = webViewContentList[itemIndex]
            return pageItemController
        }
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return webViewContentList.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
