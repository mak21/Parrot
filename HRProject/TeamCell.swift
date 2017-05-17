//
//  TeamCell.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/17/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  static let cellIdentifier = "TeamCell"
  static let cellNib = UINib(nibName: TeamCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.circlerImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
