//
//  CommentsCell.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/19/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {
  static let cellIdentifier = "CommentsCell"
  static let cellNib = UINib(nibName: CommentsCell.cellIdentifier, bundle: Bundle.main)
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
