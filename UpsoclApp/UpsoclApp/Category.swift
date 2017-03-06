//
//  Category.swift
//  appupsocl
//
//  Created by upsocl on 07-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class Category  {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("categoryKey")
    
    struct PropertyKey {
        
        static let world = "2"//"mundo"
        static let diversity = "4"//"diversidad"
        static let community = "5"//"comunidad"
        static let women = "6"//"mujer"
        static let cultura = "7"// "cultura-y-entretencion"
        static let health =  "10"//"salud"
        static let inspiration = "12"//"Inspiracion"
        static let green = "52"//"verde"
        static let food = "54"//"comida"
        static let creativity = "57"//"creatividad"
        static let colaboration = "80"//"colaboracion"
        static let relations = "303"//"relaciones"
        static let quiz = "304"//"quiz"
        static let styleLive = "305"//"estilo-de-vida"
        static let family = "306"//"familia"
        static let movies = "307"//"peliculas"
        static let beauty = "309"//"belleza"
        static let populary = "311"//"mas-populares"
    }
    
    struct PropertyKeyName {
        static let cultura = "culture"
        static let community = "community"
        static let quiz = "quiz"
        static let world = "world"
        static let green = "green"
        static let movies = "movies"
        static let inspiration = "inspiration"
        static let health = "health"
        static let relations = "relations"
        static let women = "women"
        static let family = "family"
        static let creativity = "creativity"
        static let beauty = "beauty"
        static let diversity = "diversity"
        static let styleLive = "stileLive"
        static let food = "food"
        static let populary = "populary"
        static let colaboration = "colaboration"
    }
    func countCategory() -> Int {
        var categoryCount = 0
        for elem in UserDefaults.standard.dictionaryRepresentation(){
            
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
                break
            }
        }
        return categoryCount
    }

    func clearCategoryPreference () -> Void {
        let preferences = UserDefaults.standard
        for elem in UserDefaults.standard.dictionaryRepresentation(){
            let key = elem.0
           // NSLog (key)
            switch key {
            case "culture":
                preferences.removeObject(forKey: Category.PropertyKeyName.cultura)
            case "beauty":
                 preferences.removeObject(forKey: Category.PropertyKeyName.beauty)
            case "colaboration":
                preferences.removeObject(forKey: Category.PropertyKeyName.colaboration)
            case "community":
                preferences.removeObject(forKey: Category.PropertyKeyName.community)
            case "creativity":
                preferences.removeObject(forKey: Category.PropertyKeyName.creativity)
            case "diversity":
                preferences.removeObject(forKey: Category.PropertyKeyName.diversity)
            case "family":
                preferences.removeObject(forKey: Category.PropertyKeyName.family)
            case "food":
                preferences.removeObject(forKey: Category.PropertyKeyName.food)
            case "green":
                preferences.removeObject(forKey: Category.PropertyKeyName.green)
            case "health":
                preferences.removeObject(forKey: Category.PropertyKeyName.health)
            case "inspiration":
                preferences.removeObject(forKey: Category.PropertyKeyName.inspiration)
            case "movies":
                preferences.removeObject(forKey: Category.PropertyKeyName.movies)
            case "populary":
                preferences.removeObject(forKey: Category.PropertyKeyName.populary)
            case "quiz":
                preferences.removeObject(forKey: Category.PropertyKeyName.quiz)
            case "relations":
                preferences.removeObject(forKey: Category.PropertyKeyName.relations)
            case "stileLive":
                preferences.removeObject(forKey: Category.PropertyKeyName.styleLive)
            case "women":
                preferences.removeObject(forKey: Category.PropertyKeyName.women)
            case "world":
                preferences.removeObject(forKey: Category.PropertyKeyName.world)
            default:
                break
            }
        }
        preferences.synchronize()
    }
}
