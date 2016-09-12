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
        static let community = "Comunidad"
        static let quiz = "Quiz"
        static let world = "Mundo"
        static let green = "Verde"
        static let movies = "Pelicula"
        static let inspiration = "Inspiracion"
        static let health =  "Salud"
        static let relations = "Relaciones"
        static let women = "mujer"
        static let family = "Familia"
        static let creativity = "Creatividad"
        static let beauty = "Belleza"
        static let diversity = "Diversidad"
        static let styleLive = "estilo-de-vida"
        static let food = "Comida"
        static let populary = "mas-populares"
        static let colaboration = "Colaboracion"
    }
}
