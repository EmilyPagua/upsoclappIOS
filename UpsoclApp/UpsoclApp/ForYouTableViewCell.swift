//
//  ForYouTableViewCell.swift
//  UpsoclApp
//
//  Created by upsocl on 07-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ForYouTableViewCell: UITableViewCell {

    @IBOutlet weak var imagenForyou: UIImageView!
    @IBOutlet weak var titleForyou: UILabel!
    @IBOutlet weak var authorForyou: UILabel!
    @IBOutlet weak var categoryForyou: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


