//
//  AboutUsViewController.swift
//  UpsoclApp
//
//  Created by upsocl on 21-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webContent: UIWebView!

    var servicesConnection = ServicesConnection()
    var detail = [News]()
    var progressBar = ProgressBarLoad()
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadProgressBar
        indicator = progressBar.loadBar()
        indicator.startAnimating()
        //indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)

        getInfo()
        
        //controller buttonMenu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func getInfo() {
    
        if Reachability.isConnectedToNetwork() == true {
            
            self.indicator.startAnimating()
            
            let urlPath = ApiConstants.PropertyKey.baseURL + "/pages/1039"
            
            //http://upsocl.com/wp-json/wp/v2/pages/445196   1039
            servicesConnection.loadNews(self.detail, urlPath: urlPath, completionHandler: { (moreWrapper, error) in
                
                self.detail = moreWrapper!
                DispatchQueue.main.async(execute: {
                    
                    self.webContent.loadHTMLString(self.detail[0].contentNews!, baseURL: nil)
                    self.indicator.stopAnimating()
                    return
                })
            })
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "Error en conexión a datos", message: "Esta seguro que tiene conexion a internet?", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
}
