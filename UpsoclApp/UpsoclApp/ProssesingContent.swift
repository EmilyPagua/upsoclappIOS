//
//  ProssesingContent.swift
//  appupsocl
//
//  Created by upsocl on 07-11-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

extension String {
    func captureExpression(withRegex pattern: String, replace: String) -> String {
        
        var regex: NSRegularExpression
        do{
            regex =  try NSRegularExpression(pattern: pattern , options: [])
           
            var myString = self
            let stringlength = myString.characters.count
            
            var modString = regex.stringByReplacingMatches(in: myString,
                                                                   options: .reportProgress,
                                                                   range: NSMakeRange(0, stringlength),
                                                                   withTemplate: replace)
            
            
             modString = modString.replacingOccurrences(of: "class=\"lazy\"", with: "class=\"imgifs\"")
            
            return modString
            
        }catch{
            return self
        }
    }
}
