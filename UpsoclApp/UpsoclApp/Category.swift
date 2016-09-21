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
}
