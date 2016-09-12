//
//  FoodTableViewCell.swift
//  UpsoclApp
//
//  Created by upsocl on 08-09-16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var titlePost: UILabel!
    @IBOutlet weak var authorPost: UILabel!
    @IBOutlet weak var categoryPost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
