//
//  CheckBox.swift
//  appupsocl
//
//  Created by upsocl on 16-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class CheckBoxInterest: UIButton {
    /*
    let checkImage = UIImage(named: "checkOffLine")! as UIImage
    let unCheckImage = UIImage(named: "checkOutLine")! as UIImage
    */
    let checkImage = UIImage(named: "icon_notCheck")! as UIImage
    let unCheckImage = UIImage(named: "icon_check")! as UIImage
    
    var checkValue = ""
    
    let preferences = UserDefaults.standard
    
    var isChecked : Bool = true {
        didSet{
            
            /*for elem in UserDefaults.standard.dictionaryRepresentation(){
                let key = elem.0
                print (key)
            }
            */
            if isChecked == true {
                self.setImage(checkImage, for: UIControlState())
                preferences.setValue(true, forKey: checkValue )
            }else{
                preferences.removeObject(forKey: checkValue)
                self.setImage(unCheckImage, for: UIControlState())
            }
            preferences.synchronize()
        }
    }
    
    override func awakeFromNib() {
        checkValue = self.restorationIdentifier!
        let prefe = preferences.object(forKey: checkValue)
        
        if prefe != nil{
            self.isChecked =  true
        }else {
            self.isChecked =  false
        }
        self.addTarget(self, action: #selector(CheckBoxInterest.buttonCLicked(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func buttonCLicked (_ sender: UIButton){

        checkValue = sender.restorationIdentifier!
        if sender == self{
            isChecked = !isChecked
        }
    }
}
