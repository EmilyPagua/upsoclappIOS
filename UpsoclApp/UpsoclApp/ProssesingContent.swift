//
//  ProssesingContent.swift
//  UpsoclApp
//
//  Created by upsocl on 07-11-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

extension String{
    func captureExpression(withRegex pattern: String) -> String {
        
        var regex: NSRegularExpression
        do{
            regex =  try NSRegularExpression(pattern: pattern , options: [])
           
            var myString = self
            let stringlength = myString.characters.count
            
            let modString = regex.stringByReplacingMatches(in: myString,
                                                                   options: .reportProgress,
                                                                   range: NSMakeRange(0, stringlength),
                                                                   withTemplate: "class=\"wp-image-511029 size-full\" ")
            return modString
            
        }catch{
            return self
        }
    }
}
