//
//  CheckBox.swift
//  UpsoclApp
//
//  Created by upsocl on 16-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class CheckBoxInterest: UIButton {
    
    let checkImage = UIImage(named: "checkOffLine")! as UIImage
    let unCheckImage = UIImage(named: "checkOutLine")! as UIImage
    var checkValue = ""
    
    let preferences = NSUserDefaults.standardUserDefaults()
    
    var isChecked : Bool = true {
        didSet{
            
            if isChecked == true {
                self.setImage(checkImage, forState: .Normal)
                preferences.setValue(true, forKey: checkValue )
            }else{
                preferences.removeObjectForKey(checkValue)
                self.setImage(unCheckImage, forState: .Normal)
            }
            
            preferences.synchronize()
        }
    }
    override func awakeFromNib() {
        checkValue = self.restorationIdentifier!
        let prefe = preferences.objectForKey(checkValue)
        
        if prefe != nil{
            self.isChecked =  true
        }else {
            self.isChecked =  false
        }
        self.addTarget(self, action: #selector(CheckBoxInterest.buttonCLicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func buttonCLicked (sender: UIButton){

        checkValue = sender.restorationIdentifier!
        if sender == self{
            isChecked = !isChecked
        }
    }
}
