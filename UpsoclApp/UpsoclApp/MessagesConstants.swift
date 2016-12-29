//
//  MessagesConstants.swift
//  appupsocl
//
//  Created by upsocl on 29-12-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class MessagesConstants  {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("messageConstants")
    
    struct messageKey {
        
        static let baseURL = "http://upsocl.com/wp-json/wp/v2"
    }
}
