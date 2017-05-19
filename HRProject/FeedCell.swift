//
//  FeedCell.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/18/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
protocol FeedCellDelegate: class {
  func didSelectThumbUp(isTapped: Bool)
 
}
class FeedCell: UITableViewCell {
  @IBOutlet weak var feedLabel: UILabel!
  @IBOutlet weak var thumbUpImage : UIImageView!
  
  weak var delegate : FeedCellDelegate?
  static let cellIdentifier = "FeedCell"
  static let cellNib = UINib(nibName: FeedCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
      let tapLike = UITapGestureRecognizer(target: self, action: #selector(self.handleThumbUP))
      thumbUpImage.addGestureRecognizer(tapLike)
      thumbUpImage.isUserInteractionEnabled = true
      
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  func handleThumbUP(){
      delegate?.didSelectThumbUp(isTapped: true)
    }
  


}
