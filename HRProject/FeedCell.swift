//
//  FeedCell.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/18/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
  static let cellIdentifier = "FeedCell"
  static let cellNib = UINib(nibName: FeedCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
