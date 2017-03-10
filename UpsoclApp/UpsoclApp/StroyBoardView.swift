//
//  LoginView.swift
//  appupsocl
//
//  Created by upsocl on 10-03-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

class StroyBoardView {
    
    class var sharedInstance : StroyBoardView {
        struct Static {
            static let instance: StroyBoardView = StroyBoardView()
        }
        return Static.instance
    }
    
    let myStroryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    func login(item: PostNotification! ) -> Void {
        
        let signOutPage = myStroryBoard.instantiateViewController(withIdentifier: "LoginUserController") as! LoginUserController
        signOutPage.postNotification = item
        signOutPage.isBookmark =  true
        
        let signOutPageNav = UINavigationController(rootViewController: signOutPage)
        signOutPageNav.setNavigationBarHidden(signOutPageNav.isNavigationBarHidden == false, animated: true)
        
        let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController =  signOutPageNav
    }
    
    
    func goMenu() -> Void {
        
        let signOutPage = myStroryBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let signOutPageNav = UINavigationController(rootViewController: signOutPage)
        signOutPageNav.setNavigationBarHidden(signOutPageNav.isNavigationBarHidden == false, animated: true)
        
        let appDelegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController =  signOutPageNav
    }
    
}
