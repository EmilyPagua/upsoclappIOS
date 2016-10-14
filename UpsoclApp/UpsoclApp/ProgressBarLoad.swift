//
//  ProgressBarLoad.swift
//  UpsoclApp
//
//  Created by upsocl on 08-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class ProgressBarLoad {
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    func loadBar() -> UIActivityIndicatorView {
        indicator.frame = CGRect(x: (UIScreen.main.bounds.width/2) - 20, y: 10.0, width: 40.0, height: 40.0)
        indicator.color = UIColor.blue
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return indicator
    }
}
