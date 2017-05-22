//
//  ProjectCell.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/20/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
  
  @IBOutlet weak var endedDateLabel: UILabel!
  @IBOutlet weak var createdDateLabel: UILabel!
  @IBOutlet var membersImages: [UIImageView]!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var projectNameLabel: UILabel!
  static let cellIdentifier = "ProjectCell"
static let cellNib = UINib(nibName: ProjectCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
      for image in membersImages{
        image.circlerImage()
        image.layer.borderWidth = 2.0
        image.layer.borderColor = UIColor.white.cgColor
        image.image = #imageLiteral(resourceName: "m")
      }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
