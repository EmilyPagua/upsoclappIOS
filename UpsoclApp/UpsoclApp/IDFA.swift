//
//  IDFA.swift
//  appupsocl
//
//  Created by upsocl on 09-03-17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import AdSupport

class IDFA  {
    static let shared =  IDFA()
    var limited: Bool{
        return !ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }
    
    var identifier: String? {
        guard !limited else {
            return nil
        }
        let value = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        return value
    }
}
