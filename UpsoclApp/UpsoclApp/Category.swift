//
//  Category.swift
//  UpsoclApp
//
//  Created by upsocl on 07-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class Category  {
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("categoryKey")
    
    struct PropertyKey {
        
        static let cultura = "cultura-y-entretencion"
        static let community = "comunidad"
        static let quiz = "quiz"
        static let world = "mundo"
        static let green = "verde"
        static let movies = "peliculas"
        static let inspiration = "Inspiracion"
        static let health =  "salud"
        static let relations = "relaciones"
        static let women = "mujer"
        static let family = "familia"
        static let creativity = "creatividad"
        static let beauty = "belleza"
        static let diversity = "diversidad"
        static let styleLive = "estilo-de-vida"
        static let food = "comida"
        static let populary = "mas-populares"
        static let colaboration = "colaboracion"
    }
    
    
    func countCategory() -> Int {
        
        var categoryCount = 0
        for elem in NSUserDefaults.standardUserDefaults().dictionaryRepresentation(){
            
            let key = elem.0
            
            switch key {
            case "culture":
                categoryCount += 1
            case "beauty":
                categoryCount += 1
            case "colaboration":
                categoryCount += 1
            case "community":
                categoryCount += 1
            case "creativity":
                categoryCount += 1
            case "diversity":
                categoryCount += 1
            case "family":
                categoryCount += 1
            case "food":
                categoryCount += 1
            case "green":
                categoryCount += 1
            case "health":
                categoryCount += 1
            case "inspiration":
                categoryCount += 1
            case "movies":
                categoryCount += 1
            case "populary":
                categoryCount += 1
            case "quiz":
                categoryCount += 1
            case "relations":
                categoryCount += 1
            case "stileLive":
                categoryCount += 1
            case "women":
                categoryCount += 1
            case "world":
                categoryCount += 1
            default:
                0
            }
        }
        return categoryCount
    }

    
}
