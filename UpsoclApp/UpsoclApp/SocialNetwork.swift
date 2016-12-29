//
//  SocialNetwork.swift
//  appupsocl
//
//  Created by upsocl on 29-12-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class SocialNetwork{
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("networkConstants")
    
    struct PropertyKey {
        static let sn_google = "google"
        static let sn_facebook = "facebook"
        static let sn_twitter = "twitter"
    }
}
