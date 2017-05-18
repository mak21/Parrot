//
//  PostCell.swift
//  HRProject
//
//  Created by mahmoud khudairi on 5/18/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
  @IBOutlet weak var postButton: UIButton!
  @IBOutlet weak var textView: UITextView!{
    didSet{
      textView.delegate = self
    }
  }
  @IBOutlet weak var profileImageView: UIImageView!
  static let cellIdentifier = "PostCell"
  static let cellNib = UINib(nibName: PostCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
      textView.text = "Placeholder"
      textView.textColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension PostCell: UITextViewDelegate{
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "Placeholder"
      textView.textColor = UIColor.lightGray
    }
  }
  
}
