//
//  ProgressBarLoad.swift
//  UpsoclApp
//
//  Created by upsocl on 08-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class ProgressBarLoad {
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    func loadBar() -> UIActivityIndicatorView {
        indicator.frame = CGRectMake((UIScreen.mainScreen().bounds.width/2) - 20, 10.0, 40.0, 40.0)
        indicator.color = UIColor.blueColor()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        return indicator
    }
}